package com.travelmate.backend.service.impl;

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

    @Value("${openweathermap.api.key}")
    private String apiKey;

    @Value("${openweathermap.api.url}")
    private String apiUrl;

    private static final double RAIN_PROBABILITY_THRESHOLD = 0.7; // 70%

    @Override
    public CurrentWeatherDTO fetchCurrentWeather(double latitude, double longitude) {
        CurrentWeatherResponse response = restClient.get()
                .uri(apiUrl + "/weather", uriBuilder -> uriBuilder
                        .queryParam("lat", latitude)
                        .queryParam("lon", longitude)
                        .queryParam("appid", apiKey)
                        .queryParam("units", "metric")
                        .build())
                .retrieve()
                .body(CurrentWeatherResponse.class);

        if (response == null || response.main() == null) {
            throw new IllegalStateException("Weather provider returned no data");
        }

        String condition = response.weather() == null || response.weather().isEmpty()
                ? "Unknown"
                : response.weather().get(0).description();
        double windSpeed = response.wind() == null ? 0.0 : response.wind().speed();
        double humidity = response.main().humidity();
        double temperature = response.main().temp();
        boolean isOutdoorSafe = windSpeed < 10.0;

        return new CurrentWeatherDTO(
                latitude,
                longitude,
                response.name() == null ? "Unknown" : response.name(),
                temperature,
                humidity,
                windSpeed,
                0.0,
                condition,
                isOutdoorSafe,
                Instant.now());
    }

    @Override
    @Transactional
    public void fetchAndProcessWeatherData(String city, Trip trip) {
        try {
            OpenWeatherResponse response = restClient.get()
                    .uri(apiUrl, uriBuilder -> uriBuilder
                            .queryParam("q", city)
                            .queryParam("appid", apiKey)
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
            log.error(
                    "Failed to fetch or process weather data for city {}",
                    city,
                    e);
        }
    }

    private boolean calculateIsOutdoorSafe(ForecastItem forecast) {
        // Example logic: safe if rain probability < 50% and wind speed is low.
        return forecast.pop() < 0.5 && forecast.wind().speed() < 10; // wind speed in meter/sec
    }

    private WeatherSnapshot saveDailyForecast(
            Trip trip,
            String city,
            LocalDate date,
            List<ForecastItem> dailyForecasts) {

        double temperatureHigh = dailyForecasts.stream()
                .mapToDouble(item -> item.main().temp())
                .max()
                .orElse(0.0);

        double temperatureLow = dailyForecasts.stream()
                .mapToDouble(item -> item.main().temp())
                .min()
                .orElse(0.0);

        double humidity = dailyForecasts.stream()
                .mapToDouble(item -> item.main().humidity())
                .average()
                .orElse(0.0);

        double windSpeed = dailyForecasts.stream()
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
                representative.weather().isEmpty()
                        ? "N/A"
                        : representative.weather()
                                .get(0)
                                .description());

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

    // DTOs for OpenWeatherMap Forecast API response (using records for conciseness)
    private record OpenWeatherResponse(List<ForecastItem> list) {
    }

    private record CurrentWeatherResponse(
            Main main,
            List<Weather> weather,
            Wind wind,
            String name) {
    }

    private record ForecastItem(
            long dt,
            Main main,
            List<Weather> weather,
            Wind wind,
            double pop) {
    }

    private record Main(double temp, double humidity) {
    }

    private record Weather(String main, String description) {
    }

    private record Wind(double speed) {
    }
}