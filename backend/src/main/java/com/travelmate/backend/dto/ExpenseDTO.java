package com.travelmate.backend.dto;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import com.travelmate.backend.entity.enums.ExpenseCategory;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExpenseDTO {
    private Long id;
    private Long tripId;
    private Long createdById;
    private BigDecimal amount;
    private ExpenseCategory category;
    private String description;
    private LocalDateTime createdAt;
    private boolean isShared;
}
