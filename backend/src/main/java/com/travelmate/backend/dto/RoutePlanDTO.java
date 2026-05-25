package com.travelmate.backend.dto;

import lombok.*;
import java.time.LocalDateTime;
import com.travelmate.backend.entity.enums.StrategyType;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoutePlanDTO {
    private Long id;
    private Long tripId;
    private StrategyType strategyType;
    private Double totalDistance;
    private Integer estimatedDuration;
    private Double routeScore;
    private LocalDateTime optimizedAt;
}
