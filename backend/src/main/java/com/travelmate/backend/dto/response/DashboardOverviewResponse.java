package com.travelmate.backend.dto.response;

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
public class DashboardOverviewResponse {
    private Long userId;
    private long totalTrips;
    private long activeTrips;
    private long joinedTrips;
    private BigDecimal totalSpent;
    private BigDecimal averageBudget;
    private long unreadNotifications;
    private List<TripMiniResponse> recentTrips;
}
