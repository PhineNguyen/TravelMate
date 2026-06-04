package com.travelmate.backend.controller;

import com.travelmate.backend.dto.response.BudgetSummaryResponse;
import com.travelmate.backend.dto.response.DashboardOverviewResponse;
import com.travelmate.backend.dto.response.RouteSummaryResponse;
import com.travelmate.backend.dto.response.RuntimeSummaryResponse;
import com.travelmate.backend.security.CustomUserDetails;
import com.travelmate.backend.service.TripInsightService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/insights")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class TripInsightController {
    private final TripInsightService tripInsightService;

    @GetMapping("/dashboard")
    public DashboardOverviewResponse dashboard(Authentication authentication) {
        return tripInsightService.getDashboard(currentUserId(authentication));
    }

    @GetMapping("/trips/{tripId}/budget")
    public BudgetSummaryResponse budget(@PathVariable Long tripId, Authentication authentication) {
        return tripInsightService.getBudgetSummary(tripId, currentUserId(authentication));
    }

    @GetMapping("/trips/{tripId}/route")
    public RouteSummaryResponse route(@PathVariable Long tripId, Authentication authentication) {
        return tripInsightService.getRouteSummary(tripId, currentUserId(authentication));
    }

    @GetMapping("/trips/{tripId}/runtime")
    public RuntimeSummaryResponse runtime(@PathVariable Long tripId, Authentication authentication) {
        return tripInsightService.getRuntimeSummary(tripId, currentUserId(authentication));
    }

    private Long currentUserId(Authentication authentication) {
        Object principal = authentication.getPrincipal();
        if (principal instanceof CustomUserDetails customUserDetails) {
            return customUserDetails.getId();
        }
        throw new IllegalArgumentException("Authenticated user not available");
    }
}
