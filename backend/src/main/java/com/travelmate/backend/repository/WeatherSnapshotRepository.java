package com.travelmate.backend.repository;

import com.travelmate.backend.entity.WeatherSnapshot;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.Instant;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface WeatherSnapshotRepository extends JpaRepository<WeatherSnapshot, Long> {

    List<WeatherSnapshot> findByTripId(Long tripId);

    Page<WeatherSnapshot> findByTripId(Long tripId, Pageable pageable);

    Optional<WeatherSnapshot> findByTripIdAndDate(Long tripId, LocalDate date);

    boolean existsByTripIdAndDate(Long tripId, LocalDate date);

    List<WeatherSnapshot> findByCity(String city);

    List<WeatherSnapshot> findByProviderName(String providerName);

    List<WeatherSnapshot> findByTripIdAndProviderName(Long tripId, String providerName);

    List<WeatherSnapshot> findByExpiresAtBefore(Instant time);

    List<WeatherSnapshot> findByIsOutdoorSafeTrue();

    List<WeatherSnapshot> findByTripIdOrderByDateDesc(Long tripId);

    Optional<WeatherSnapshot> findTopByTripIdOrderByDateDesc(Long tripId);
}