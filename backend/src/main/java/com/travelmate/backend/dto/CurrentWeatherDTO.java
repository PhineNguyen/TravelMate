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
}