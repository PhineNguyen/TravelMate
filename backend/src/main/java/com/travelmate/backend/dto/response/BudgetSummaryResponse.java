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
public class BudgetSummaryResponse {
    private Long tripId;
    private BigDecimal plannedBudget;
    private BigDecimal spentBudget;
    private BigDecimal remainingBudget;
    private BigDecimal utilizationPercent;
    private String warningLevel;
    private long expenseCount;
    private List<CategoryBreakdownResponse> byCategory;
}
