package com.travelmate.backend.dto.response;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RuntimeSummaryResponse {
    private Long tripId;
    private LocalDate tripDate;
    private Integer currentDay;
    private String currentDestination;
    private long completedItems;
    private long upcomingItems;
    private long activeParticipants;
    private long unreadNotifications;
    private BigDecimal spentBudget;
    private BigDecimal plannedBudget;
    private List<String> alerts;
}
