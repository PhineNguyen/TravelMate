package com.travelmate.backend.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import com.travelmate.backend.entity.enums.ExpenseCategory;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExpenseRequest {
    private Long id;
    private Long tripId;
    private Long createdById;
    private BigDecimal amount;
    private ExpenseCategory category;
    private String description;
    private Boolean isShared;
}
