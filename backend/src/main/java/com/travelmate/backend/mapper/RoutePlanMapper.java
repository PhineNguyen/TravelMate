package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.RoutePlanDTO;
import com.travelmate.backend.entity.RoutePlan;

public class RoutePlanMapper {
    public static RoutePlanDTO toDto(RoutePlan r) {
        if (r == null)
            return null;
        return RoutePlanDTO.builder()
                .id(r.getId())
                .tripId(r.getTrip() != null ? r.getTrip().getId() : null)
                .strategyType(r.getStrategyType())
                .totalDistance(r.getTotalDistance())
                .estimatedDuration(r.getEstimatedDuration())
                .routeScore(r.getRouteScore())
                .optimizedAt(r.getOptimizedAt())
                .build();
    }
}
