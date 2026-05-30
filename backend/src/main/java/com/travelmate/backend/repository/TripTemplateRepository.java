package com.travelmate.backend.repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
//=======================
import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.TripTemplate;

public interface TripTemplateRepository extends JpaRepository<TripTemplate, Long> {

    Optional<TripTemplate> findByTitle(String title);

    boolean existsByTitle(String title);

    List<TripTemplate> findByCategory(String category);

    List<TripTemplate> findByDestination(String destination);

    List<TripTemplate> findByCategoryAndDestination(String category, String destination);

    // Pagination sorted by popularity
    Page<TripTemplate> findByCategoryOrderByPopularityScoreDescCreatedAtDesc(String category, Pageable pageable);

    Page<TripTemplate> findByDestinationOrderByPopularityScoreDescCreatedAtDesc(String destination, Pageable pageable);

    Page<TripTemplate> findByEstimatedBudgetBetweenOrderByPopularityScoreDescCreatedAtDesc(BigDecimal minBudget,
            BigDecimal maxBudget, Pageable pageable);

    List<TripTemplate> findByDurationLessThanEqualOrderByPopularityScoreDesc(Integer duration);

    List<TripTemplate> findTop10ByOrderByPopularityScoreDescCreatedAtDesc();

    List<TripTemplate> findByCreatedAtAfterOrderByCreatedAtDesc(LocalDateTime createdAt);

}
