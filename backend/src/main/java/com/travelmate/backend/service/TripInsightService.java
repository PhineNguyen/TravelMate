package com.travelmate.backend.service;

import com.travelmate.backend.dto.response.BudgetSummaryResponse;
import com.travelmate.backend.dto.response.DashboardOverviewResponse;
import com.travelmate.backend.dto.response.RouteSummaryResponse;
import com.travelmate.backend.dto.response.RuntimeSummaryResponse;

public interface TripInsightService {
    DashboardOverviewResponse getDashboard(Long userId);

    BudgetSummaryResponse getBudgetSummary(Long tripId, Long userId);

    RouteSummaryResponse getRouteSummary(Long tripId, Long userId);

    RuntimeSummaryResponse getRuntimeSummary(Long tripId, Long userId);
}
