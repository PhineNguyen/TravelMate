package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.AnalyticsSnapshotDTO;
import com.travelmate.backend.entity.AnalyticsSnapshot;

public class AnalyticsSnapshotMapper {
    public static AnalyticsSnapshotDTO toDto(AnalyticsSnapshot a) {
        if (a == null)
            return null;
        return AnalyticsSnapshotDTO.builder()
                .id(a.getId())
                .tripId(a.getTrip() != null ? a.getTrip().getId() : null)
                .totalTrips(a.getTotalTrips())
                .avgBudget(a.getAvgBudget())
                .totalSpent(a.getTotalSpent())
                .favoriteCategory(a.getFavoriteCategory())
                .mostVisitedDestination(a.getMostVisitedDestination())
                .travelPersonality(a.getTravelPersonality())
                .generatedAt(a.getGeneratedAt())
                .build();
    }
}
