package com.travelmate.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.RoutePlan;
import com.travelmate.backend.entity.enums.StrategyType;

public interface RoutePlanRepository extends JpaRepository<RoutePlan, Long> {

    List<RoutePlan> findByTripId(Long tripId);

    List<RoutePlan> findByTripIdOrderByOptimizedAtDesc(Long tripId);

    Optional<RoutePlan> findTopByTripIdOrderByOptimizedAtDesc(Long tripId);

    List<RoutePlan> findByTripIdAndStrategyType(Long tripId, StrategyType strategyType);

    boolean existsByTripIdAndStrategyType(Long tripId, StrategyType strategyType);

    List<RoutePlan> findByStrategyTypeOrderByRouteScoreDesc(StrategyType strategyType);

}
