package com.travelmate.backend.service.impl;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.travelmate.backend.dto.CurrentWeatherDTO;
import com.travelmate.backend.service.WeatherApiClientService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.time.Instant;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class WeatherApiClientServiceImpl implements WeatherApiClientService {

    private final RestClient restClient;

    @Value("${openweathermap.api.key:}")
    private String apiKey;

    @Value("${openweathermap.api.url:https://api.openweathermap.org/data/2.5}")
    private String apiUrl;

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

    // DTOs for OpenWeatherMap API responses (using records with Jackson ignore unknown)
    @JsonIgnoreProperties(ignoreUnknown = true)
    private record CurrentWeatherResponse(
            Main main,
            List<Weather> weather,
            Wind wind,
            String name,
            Long dt) {
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
