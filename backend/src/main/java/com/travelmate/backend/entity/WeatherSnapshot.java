package com.travelmate.backend.entity;

import com.fasterxml.jackson.databind.JsonNode;
import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.hibernate.annotations.JdbcTypeCode;
import org.hibernate.type.SqlTypes;

import java.time.Instant;
import java.time.LocalDate;

@Entity
@Table(name = "weather_snapshot", indexes = {
        @Index(name = "idx_weather_trip_date", columnList = "trip_id, date"),
        @Index(name = "idx_weather_city", columnList = "city"),
        @Index(name = "idx_weather_provider", columnList = "provider_name")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WeatherSnapshot {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "trip_id")
    private Long tripId;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name = "temperature")
    private Double temperature;

    @Column(name = "humidity")
    private Double humidity;

    @Column(name = "rain_probability")
    private Double rainProbability;

    @Column(name = "condition", length = 128)
    private String condition;

    @Column(name = "wind_speed")
    private Double windSpeed;

    @Column(name = "uv_index")
    private Double uvIndex;

    @Column(name = "visibility")
    private Double visibility;

    @Column(name = "alert_level", length = 64)
    private String alertLevel;

    @Column(name = "city", length = 200)
    private String city;

    @Column(name = "is_outdoor_safe", nullable = false)
    private boolean isOutdoorSafe = false;

    @Column(name = "expires_at")
    private Instant expiresAt;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private Instant updatedAt;

    @Column(name = "provider_name", length = 128)
    private String providerName;

    @Column(name = "provider_recorded_at")
    private Instant providerRecordedAt;

    @Column(name = "provider_id", length = 255)
    private String providerId;

    @JdbcTypeCode(SqlTypes.JSON)
    @Column(name = "provider_payload", columnDefinition = "jsonb")
    private JsonNode providerPayload;
}