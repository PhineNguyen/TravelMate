package com.travelmate.backend.entity;

import java.time.Instant;

import org.hibernate.annotations.CreationTimestamp;

import com.travelmate.backend.entity.enums.AlertSeverity;
import com.travelmate.backend.entity.enums.AlertType;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "weather_alert", indexes = {
        @Index(name = "idx_alert_trip_snapshot", columnList = "trip_id, snapshot_id"),
        @Index(name = "idx_alert_unresolved", columnList = "trip_id") // add partial index in SQL
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class WeatherAlert {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trip_id", nullable = false)
    private Trip trip;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "snapshot_id", nullable = false)
    private WeatherSnapshot snapshot;

    @Enumerated(EnumType.STRING)
    @Column(length = 50)
    private AlertSeverity severity;

    @Enumerated(EnumType.STRING)
    @Column(name = "alert_type", length = 50)
    private AlertType alertType;

    @Column(name = "suggested_action", columnDefinition = "TEXT")
    private String suggestedAction;

    @Column(name = "is_resolved", nullable = false)
    private boolean isResolved = false;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private Instant createdAt;

    @Column(name = "resolved_at")
    private Instant resolvedAt;
}