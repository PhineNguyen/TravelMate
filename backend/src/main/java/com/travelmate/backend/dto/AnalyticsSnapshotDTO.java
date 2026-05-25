package com.travelmate.backend.dto;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AnalyticsSnapshotDTO {
    private Long id;
    private Long tripId;
    private Integer totalTrips;
    private BigDecimal avgBudget;
    private BigDecimal totalSpent;
    private String favoriteCategory;
    private String mostVisitedDestination;
    private String travelPersonality;
    private LocalDateTime generatedAt;
}
