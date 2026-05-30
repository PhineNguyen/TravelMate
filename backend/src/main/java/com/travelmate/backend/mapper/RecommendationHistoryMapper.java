package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.RecommendationHistoryDTO;
import com.travelmate.backend.entity.RecommendationHistory;

public class RecommendationHistoryMapper {
    public static RecommendationHistoryDTO toDto(RecommendationHistory r) {
        if (r == null)
            return null;
        return RecommendationHistoryDTO.builder()
                .id(r.getId())
                .userId(r.getUser() != null ? r.getUser().getId() : null)
                .tripId(r.getTrip() != null ? r.getTrip().getId() : null)
                .placeId(r.getPlace() != null ? r.getPlace().getId() : null)
                .score(r.getScore())
                .sourceEngine(r.getSourceEngine())
                .queryContext(r.getQueryContext())
                .recommendationReason(r.getRecommendationReason())
                .generatedAt(r.getGeneratedAt())
                .build();
    }
}
