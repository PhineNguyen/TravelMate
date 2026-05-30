package com.travelmate.backend.repository;

import java.time.Instant;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.RecommendationHistory;

public interface RecommendationHistoryRepository extends JpaRepository<RecommendationHistory, Long> {

    List<RecommendationHistory> findByUserId(Long userId);

    Page<RecommendationHistory> findByUserIdOrderByGeneratedAtDesc(Long userId, Pageable pageable);

    List<RecommendationHistory> findByTripId(Long tripId);

    Page<RecommendationHistory> findByTripIdOrderByGeneratedAtDesc(Long tripId, Pageable pageable);

    List<RecommendationHistory> findByPlaceId(Long placeId);

    List<RecommendationHistory> findBySourceEngine(String sourceEngine);

    List<RecommendationHistory> findByUserIdAndSourceEngine(Long userId, String sourceEngine);

    List<RecommendationHistory> findByScoreGreaterThanEqual(Double minScore);

    List<RecommendationHistory> findByGeneratedAtAfter(Instant generatedAt);

}
