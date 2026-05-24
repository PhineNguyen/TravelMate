package com.travelmate.backend.repository;

import com.travelmate.backend.entity.WeatherAlert;
import com.travelmate.backend.entity.enums.AlertSeverity;
import com.travelmate.backend.entity.enums.AlertType;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

public interface WeatherAlertRepository extends JpaRepository<WeatherAlert, Long> {

    // ── Basic lookups ──────────────────────────────────────────

    // Get all alerts for a specific trip
    List<WeatherAlert> findByTripId(Long tripId);

    // Get only unresolved alerts for a specific trip
    List<WeatherAlert> findByTripIdAndIsResolvedFalse(Long tripId);

    // Get alerts for a trip with pagination
    Page<WeatherAlert> findByTripId(Long tripId, Pageable pageable);

    // Get all unresolved alerts in the system (admin use)
    Page<WeatherAlert> findByIsResolvedFalse(Pageable pageable);

    // Filter alerts by type (Rain, Storm, Heatwave, Flood...)
    List<WeatherAlert> findByAlertType(AlertType alertType);

    // Filter alerts by severity (LOW, MEDIUM, HIGH, CRITICAL)
    List<WeatherAlert> findBySeverity(AlertSeverity severity);

    // ── Combined conditions ────────────────────────────────────

    // Get unresolved alerts for a trip filtered by severity level
    List<WeatherAlert> findByTripIdAndSeverityAndIsResolvedFalse(Long tripId, AlertSeverity severity);

    // ── Time range ─────────────────────────────────────────────

    // Get alerts created within a specific time range
    List<WeatherAlert> findByCreatedAtBetween(Instant from, Instant to);

    // ── Special queries ────────────────────────────────────────

    // Get the most recent alert for a trip
    Optional<WeatherAlert> findTopByTripIdOrderByCreatedAtDesc(Long tripId);

    // Count unresolved alerts for a trip (used for badge display)
    long countByTripIdAndIsResolvedFalse(Long tripId);
}