package com.travelmate.backend.dto.request;

import java.math.BigDecimal;
import java.time.LocalDate;
import com.travelmate.backend.entity.enums.PlanningMode;
import com.travelmate.backend.entity.enums.TripStatus;
import jakarta.validation.constraints.Min;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor; // 1. Nhớ import thư viện này

@Data
@NoArgsConstructor // 2. Bổ sung annotation này vào đây
@AllArgsConstructor
@Builder
public class TripUpdateRequest {
    private Long id;
    private String destination;
    private LocalDate startDate;

    @Min(value = 1, message = "Duration must be at least 1 day")
    private Integer duration;

    @Min(value = 1, message = "Traveler count must be at least 1 person")
    private Integer travelerCount;

    private BigDecimal totalBudget;
    private PlanningMode planningMode;
    private Long templateId;
    private Boolean isCustomized;
    private TripStatus tripStatus;
}