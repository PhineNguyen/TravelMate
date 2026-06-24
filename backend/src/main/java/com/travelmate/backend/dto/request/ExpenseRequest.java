package com.travelmate.backend.dto.request;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate; // ✅ Thêm import LocalDate

import com.travelmate.backend.entity.enums.ExpenseCategory;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExpenseRequest {
    private Long id;

    @NotNull(message = "Trip ID is required")
    private Long tripId;

    @NotNull(message = "Creator ID is required")
    private Long createdById;

    @NotNull(message = "Amount is required")
    @DecimalMin(value = "0.01", message = "Amount must be greater than 0")
    private BigDecimal amount;

    @NotNull(message = "Category is required")
    private ExpenseCategory category;

    @Size(max = 500, message = "Description cannot exceed 500 characters")
    private String description;

    private LocalDate expenseDate;

    private Boolean isShared;
}