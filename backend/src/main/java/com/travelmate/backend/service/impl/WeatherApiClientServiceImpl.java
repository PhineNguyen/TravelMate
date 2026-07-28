package com.travelmate.backend.service.impl;

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

            if (response != null && response.list() != null && !response.list().isEmpty()) {
                ForecastItem forecast = response.list().get(0); // Get the most immediate forecast
                double rainProbability = forecast.pop();

                boolean isOutdoorSafe = calculateIsOutdoorSafe(forecast);

                // Create and save a snapshot of the current weather data
                WeatherSnapshot snapshot = createAndSaveWeatherSnapshot(trip, city, forecast, isOutdoorSafe);

                log.info("Weather for {}: Rain probability: {}, Outdoor safe: {}", city, rainProbability,
                        isOutdoorSafe);

                if (rainProbability > RAIN_PROBABILITY_THRESHOLD) {
                    createWeatherAlert(trip, snapshot, rainProbability);
                }
            }
        } catch (Exception e) {
            log.error("Failed to fetch or process weather data for city {}: {}", city, e.getMessage());
        }
    }

    private boolean calculateIsOutdoorSafe(ForecastItem forecast) {
        // Example logic: safe if rain probability < 50% and wind speed is low.
        return forecast.pop() < 0.5 && forecast.wind().speed() < 10; // wind speed in meter/sec
    }

    private WeatherSnapshot createAndSaveWeatherSnapshot(Trip trip, String city, ForecastItem forecast,
            boolean isOutdoorSafe) {
        WeatherSnapshot snapshot = WeatherSnapshot.builder()
                .trip(trip)
                .date(LocalDate.now()) // Using current date for the snapshot
                .city(city)
                .temperature(forecast.main().temp())
                .rainProbability(forecast.pop())
                .windSpeed(forecast.wind().speed())
                .condition(forecast.weather().isEmpty() ? "N/A" : forecast.weather().get(0).description())
                .isOutdoorSafe(isOutdoorSafe)
                .providerName("OpenWeatherMap")
                .build();
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

    private record ForecastItem(Main main, List<Weather> weather, Wind wind, double pop) {
    }

    private record Main(double temp) {
    }

    private record Weather(String main, String description) {
    }

    private record Wind(double speed) {
    }
}