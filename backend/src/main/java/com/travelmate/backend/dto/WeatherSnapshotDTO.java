package com.travelmate.backend.dto;

import com.fasterxml.jackson.databind.JsonNode;
import java.time.LocalDate;
import java.time.Instant;
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class WeatherSnapshotDTO {
    private Long id;
    private Long tripId;
    private LocalDate date;
    private Double temperature;
    private Double humidity;
    private Double rainProbability;
    private String condition;
    private Double windSpeed;
    private Double uvIndex;
    private Double visibility;
    private String alertLevel;
    private String city;
    private Boolean isOutdoorSafe;
    private Instant expiresAt;
    private Instant createdAt;
    private Instant updatedAt;
    private String providerName;
    private Instant providerRecordedAt;
    private String providerId;
    private JsonNode providerPayload;
}