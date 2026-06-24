package com.travelmate.backend.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import com.travelmate.backend.entity.enums.PlanningMode;
import com.travelmate.backend.entity.enums.TripStatus;
import lombok.*;

@Data
@NoArgsConstructor // ✅ Bổ sung để tránh lỗi mapping/đọc ghi dữ liệu (Jackson, Redis, MapStruct)
@AllArgsConstructor
@Builder
public class TripDTO {
    private Long id;
    private Long ownerId;
    private String destination;
    private LocalDate startDate;
    private Integer duration;

    private Integer travelerCount;

    private BigDecimal totalBudget;
    private PlanningMode planningMode;
    private Long templateId;
    private Boolean isCustomized;
    private TripStatus tripStatus;
    private String inviteCode;

    // ✅ Bổ sung bộ đôi trường phục vụ tính năng Xóa mềm (Soft Delete)
    private Boolean isDeleted;
    private LocalDateTime deletedAt;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}