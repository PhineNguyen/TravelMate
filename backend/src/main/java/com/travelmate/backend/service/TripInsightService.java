package com.travelmate.backend.service;

import com.travelmate.backend.dto.response.BudgetSummaryResponse;
import com.travelmate.backend.dto.response.RuntimeSummaryResponse;

public interface TripInsightService {
    BudgetSummaryResponse getBudgetSummary(Long tripId, Long userId);

    RuntimeSummaryResponse getRuntimeSummary(Long tripId, Long userId);
}
