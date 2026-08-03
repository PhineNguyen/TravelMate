package com.travelmate.backend.dto.response;

import java.math.BigDecimal;
import com.travelmate.backend.entity.enums.ExpenseCategory;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class CategoryBreakdownResponse {
    private ExpenseCategory category;
    private BigDecimal amount;
}
