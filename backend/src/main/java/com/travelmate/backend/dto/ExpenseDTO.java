package com.travelmate.backend.dto;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;
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

    // Ngày phát sinh chi tiêu thực tế (Dùng LocalDate)
    private LocalDate expenseDate;

    private LocalDateTime createdAt;
    private Boolean isShared;

    // Trạng thái và thời gian xóa mềm để đồng bộ cấu trúc với TripDTO
    private Boolean isDeleted;
    private LocalDateTime deletedAt;
}