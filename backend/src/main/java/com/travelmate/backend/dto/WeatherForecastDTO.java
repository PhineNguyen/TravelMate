package com.travelmate.backend.dto;

import java.time.LocalDate;

public record WeatherForecastDTO(
        LocalDate date,
        Double temperatureHigh,
        Double temperatureLow,
        String condition,
        Double humidity,
        Double windSpeed,
        Double rainProbability,
        Boolean isOutdoorSafe) {
}