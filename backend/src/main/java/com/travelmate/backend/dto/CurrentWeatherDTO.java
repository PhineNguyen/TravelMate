package com.travelmate.backend.dto;

import java.time.Instant;

public record CurrentWeatherDTO(
        Double latitude,
        Double longitude,
        String city,
        Double temperature,
        Double humidity,
        Double windSpeed,
        Double rainProbability,
        String condition,
        Boolean isOutdoorSafe,
        Instant providerRecordedAt) {

    public static CurrentWeatherDTO fallback(Double latitude, Double longitude) {
        return new CurrentWeatherDTO(
                latitude,
                longitude,
                "Unknown",
                25.0,
                50.0,
                0.0,
                0.0,
                "Weather data temporarily unavailable",
                true,
                Instant.now());
    }

    public static CurrentWeatherDTO fallback(Double latitude, Double longitude, String conditionMessage) {
        return new CurrentWeatherDTO(
                latitude,
                longitude,
                "Unknown",
                25.0,
                50.0,
                0.0,
                0.0,
                conditionMessage != null ? conditionMessage : "Weather data temporarily unavailable",
                true,
                Instant.now());
    }
}