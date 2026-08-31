package com.travelmate.backend.service.impl;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.travelmate.backend.dto.CurrentWeatherDTO;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.WeatherAlert;
import com.travelmate.backend.entity.enums.AlertSeverity;
import com.travelmate.backend.entity.enums.AlertType;
import com.travelmate.backend.entity.WeatherSnapshot;
import com.travelmate.backend.repository.WeatherAlertRepository;
import com.travelmate.backend.service.WeatherApiClientService;
import com.travelmate.backend.repository.WeatherSnapshotRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClient;

import java.time.LocalDate;
import java.util.List;
import java.time.Instant;
import java.time.ZoneId;
import java.util.Map;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class WeatherApiClientServiceImpl implements WeatherApiClientService {

    private final RestClient restClient;
    private final WeatherAlertRepository weatherAlertRepository;
    private final WeatherSnapshotRepository weatherSnapshotRepository;

    @Value("${openweathermap.api.key:}")
    private String apiKey;

    @Value("${openweathermap.api.url:https://api.openweathermap.org/data/2.5}")
    private String apiUrl;

    private static final double RAIN_PROBABILITY_THRESHOLD = 0.7; // 70%

    @Override
    public CurrentWeatherDTO fetchCurrentWeather(double latitude, double longitude) {
        // Validate coordinates
        if (Double.isNaN(latitude) || Double.isInfinite(latitude) || latitude < -90.0 || latitude > 90.0) {
            throw new IllegalArgumentException("Latitude must be between -90 and 90");
        }
        if (Double.isNaN(longitude) || Double.isInfinite(longitude) || longitude < -180.0 || longitude > 180.0) {
            throw new IllegalArgumentException("Longitude must be between -180 and 180");
        }

        // Handle missing API Key gracefully with fallback
        if (apiKey == null || apiKey.trim().isEmpty()) {
            log.warn("OpenWeatherMap API key is not configured. Returning fallback weather for coordinates [lat={}, lon={}]", latitude, longitude);
            return CurrentWeatherDTO.fallback(latitude, longitude);
        }

        try {
            CurrentWeatherResponse response = restClient.get()
                    .uri(apiUrl + "/weather", uriBuilder -> uriBuilder
                            .queryParam("lat", latitude)
                            .queryParam("lon", longitude)
                            .queryParam("appid", apiKey.trim())
                            .queryParam("units", "metric")
                            .build())
                    .retrieve()
                    .body(CurrentWeatherResponse.class);

            if (response == null || response.main() == null) {
                log.warn("OpenWeatherMap returned empty data for coordinates [lat={}, lon={}]. Using fallback.", latitude, longitude);
                return CurrentWeatherDTO.fallback(latitude, longitude);
            }

            String condition = (response.weather() == null || response.weather().isEmpty() || response.weather().get(0) == null)
                    ? "Unknown"
                    : (response.weather().get(0).description() != null ? response.weather().get(0).description() : "Unknown");

            double windSpeed = (response.wind() == null || response.wind().speed() == null)
                    ? 0.0
                    : response.wind().speed();

            double humidity = response.main().humidity() != null ? response.main().humidity() : 0.0;
            double temperature = response.main().temp() != null ? response.main().temp() : 0.0;

            String conditionLower = condition.toLowerCase();
            boolean isOutdoorSafe = windSpeed < 10.0
                    && !conditionLower.contains("storm")
                    && !conditionLower.contains("thunderstorm")
                    && !conditionLower.contains("tornado")
                    && !conditionLower.contains("hurricane");

            String city = (response.name() == null || response.name().trim().isEmpty()) ? "Unknown" : response.name().trim();

            Instant recordedAt = (response.dt() != null && response.dt() > 0)
                    ? Instant.ofEpochSecond(response.dt())
                    : Instant.now();

            return new CurrentWeatherDTO(
                    latitude,
                    longitude,
                    city,
                    temperature,
                    humidity,
                    windSpeed,
                    0.0,
                    condition,
                    isOutdoorSafe,
                    recordedAt);
        } catch (Exception e) {
            // Mask API key: only log lat, lon and exception message
            log.error("Failed to fetch current weather from provider for coordinates [lat={}, lon={}]: {}. Using safe fallback.",
                    latitude, longitude, e.getMessage());
            return CurrentWeatherDTO.fallback(latitude, longitude);
        }
    }

    @Override
    @Transactional
    public void fetchAndProcessWeatherData(String city, Trip trip) {
        if (city == null || city.trim().isEmpty() || trip == null) {
            log.warn("City or Trip is null/empty, skipping weather forecast fetch");
            return;
        }

        if (apiKey == null || apiKey.trim().isEmpty()) {
            log.warn("OpenWeatherMap API key is not configured. Skipping weather forecast fetch for city {}", city);
            return;
        }

        try {
            OpenWeatherResponse response = restClient.get()
                    .uri(apiUrl + "/forecast", uriBuilder -> uriBuilder
                            .queryParam("q", city.trim())
                            .queryParam("appid", apiKey.trim())
                            .queryParam("units", "metric")
                            .build())
                    .retrieve()
                    .body(OpenWeatherResponse.class);

            if (response == null
                    || response.list() == null
                    || response.list().isEmpty()) {
                log.warn("No weather forecast returned for city {}", city);
                return;
            }

            Map<LocalDate, List<ForecastItem>> forecastsByDate = response.list()
                    .stream()
                    .collect(Collectors.groupingBy(forecast -> Instant.ofEpochSecond(forecast.dt())
                            .atZone(ZoneId.systemDefault())
                            .toLocalDate()));

            for (Map.Entry<LocalDate, List<ForecastItem>> entry : forecastsByDate.entrySet()) {

                WeatherSnapshot snapshot = saveDailyForecast(
                        trip,
                        city,
                        entry.getKey(),
                        entry.getValue());

                if (snapshot.getRainProbability() != null
                        && snapshot.getRainProbability() >= RAIN_PROBABILITY_THRESHOLD * 100) {

                    createWeatherAlert(
                            trip,
                            snapshot,
                            snapshot.getRainProbability() / 100);
                }
            }
        } catch (Exception e) {
            log.error("Failed to fetch or process weather forecast for city {}: {}", city, e.getMessage());
        }
    }

    private WeatherSnapshot saveDailyForecast(
            Trip trip,
            String city,
            LocalDate date,
            List<ForecastItem> dailyForecasts) {

        double temperatureHigh = dailyForecasts.stream()
                .filter(item -> item.main() != null && item.main().temp() != null)
                .mapToDouble(item -> item.main().temp())
                .max()
                .orElse(0.0);

        double temperatureLow = dailyForecasts.stream()
                .filter(item -> item.main() != null && item.main().temp() != null)
                .mapToDouble(item -> item.main().temp())
                .min()
                .orElse(0.0);

        double humidity = dailyForecasts.stream()
                .filter(item -> item.main() != null && item.main().humidity() != null)
                .mapToDouble(item -> item.main().humidity())
                .average()
                .orElse(0.0);

        double windSpeed = dailyForecasts.stream()
                .filter(item -> item.wind() != null && item.wind().speed() != null)
                .mapToDouble(item -> item.wind().speed())
                .max()
                .orElse(0.0);

        double rainProbabilityRatio = dailyForecasts.stream()
                .mapToDouble(ForecastItem::pop)
                .max()
                .orElse(0.0);

        double rainProbabilityPercent = rainProbabilityRatio * 100;

        ForecastItem representative = dailyForecasts.stream()
                .max((first, second) -> Double.compare(first.pop(), second.pop()))
                .orElse(dailyForecasts.get(0));

        boolean isOutdoorSafe = rainProbabilityPercent < 50.0
                && windSpeed < 10.0;

        WeatherSnapshot snapshot = weatherSnapshotRepository
                .findByTripIdAndDate(trip.getId(), date)
                .orElseGet(WeatherSnapshot::new);

        snapshot.setTrip(trip);
        snapshot.setDate(date);
        snapshot.setCity(city);

        snapshot.setTemperature(
                (temperatureHigh + temperatureLow) / 2);

        snapshot.setTemperatureHigh(temperatureHigh);
        snapshot.setTemperatureLow(temperatureLow);

        snapshot.setHumidity(humidity);
        snapshot.setWindSpeed(windSpeed);
        snapshot.setRainProbability(rainProbabilityPercent);

        snapshot.setCondition(
                (representative.weather() == null || representative.weather().isEmpty() || representative.weather().get(0) == null)
                        ? "N/A"
                        : representative.weather().get(0).description());

        snapshot.setOutdoorSafe(isOutdoorSafe);
        snapshot.setAlertLevel(
                isOutdoorSafe ? "NORMAL" : "WARNING");
        snapshot.setProviderName("OpenWeatherMap");

        return weatherSnapshotRepository.save(snapshot);
    }

    private void createWeatherAlert(Trip trip, WeatherSnapshot snapshot, double rainProbability) {
        // Check if a similar alert already exists to avoid duplicates
        if (weatherAlertRepository.existsByTripIdAndAlertTypeAndIsResolvedFalse(trip.getId(), AlertType.RAIN)) {
            log.info("An unresolved weather alert already exists for trip {}", trip.getId());
            return;
        }

        String action = String.format(
                "High probability of rain (%.0f%%). Consider moving outdoor activities indoors or rescheduling.",
                rainProbability * 100);

        WeatherAlert alert = WeatherAlert.builder()
                .trip(trip)
                .snapshot(snapshot)
                .alertType(AlertType.RAIN)
                .severity(AlertSeverity.HIGH)
                .suggestedAction(action)
                .isResolved(false)
                .build();

        weatherAlertRepository.save(alert);
        log.info("Created a high rain probability weather alert for trip {}", trip.getId());
    }

    // DTOs for OpenWeatherMap API responses (using records with Jackson ignore unknown)
    @JsonIgnoreProperties(ignoreUnknown = true)
    private record OpenWeatherResponse(List<ForecastItem> list) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    private record CurrentWeatherResponse(
            Main main,
            List<Weather> weather,
            Wind wind,
            String name,
            Long dt) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    private record ForecastItem(
            long dt,
            Main main,
            List<Weather> weather,
            Wind wind,
            double pop) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    private record Main(Double temp, Double humidity) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    private record Weather(String main, String description) {
    }

    @JsonIgnoreProperties(ignoreUnknown = true)
    private record Wind(Double speed) {
    }
}