package com.travelmate.backend.dto;

import lombok.*;
import java.time.Instant;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RecommendationHistoryDTO {
    private Long id;
    private Long userId;
    private Long tripId;
    private Long placeId;
    private Double score;
    private String sourceEngine;
    private String queryContext;
    private String recommendationReason;
    private Instant generatedAt;
}
