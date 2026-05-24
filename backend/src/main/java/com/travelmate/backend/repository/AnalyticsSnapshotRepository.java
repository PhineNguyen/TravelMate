package com.travelmate.backend.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.AnalyticsSnapshot;

public interface AnalyticsSnapshotRepository extends JpaRepository<AnalyticsSnapshot, Long> {

    List<AnalyticsSnapshot> findByTripIdOrderByGeneratedAtDesc(Long tripId);

    Page<AnalyticsSnapshot> findByTripIdOrderByGeneratedAtDesc(Long tripId, Pageable pageable);

    Optional<AnalyticsSnapshot> findTopByTripIdOrderByGeneratedAtDesc(Long tripId);

    List<AnalyticsSnapshot> findByTripIdAndGeneratedAtAfter(Long tripId, LocalDateTime generatedAt);
}