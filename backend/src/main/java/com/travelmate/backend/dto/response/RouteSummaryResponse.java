package com.travelmate.backend.dto.response;

import com.travelmate.backend.entity.enums.StrategyType;
import java.math.BigDecimal;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RouteSummaryResponse {
    private Long tripId;
    private StrategyType strategyType;
    private BigDecimal totalDistanceKm;
    private Integer estimatedDurationMinutes;
    private String nextStop;
    private List<RouteStopResponse> stops;
}
