package com.travelmate.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import com.travelmate.backend.entity.enums.ExpenseCategory;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ExpenseResponse {
    private Long id;
    private Long tripId;
    private Long createdById;
    private BigDecimal amount;
    private ExpenseCategory category;
    private String description;

    private LocalDate expenseDate;

    private LocalDateTime createdAt;
    private Boolean isShared;

    // Trạng thái xóa mềm phục vụ kiểm tra hoặc xử lý logic ở Client nếu cần
    private Boolean isDeleted;
    private LocalDateTime deletedAt;
}