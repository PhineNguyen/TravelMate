package com.travelmate.backend.dto.request;

import java.math.BigDecimal;
import java.time.LocalDate;
import com.travelmate.backend.entity.enums.PlanningMode;
import com.travelmate.backend.entity.enums.TripStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TripRequest {
    private Long id;
    private Long ownerId;
    private String destination;
    private LocalDate startDate;
    private Integer duration;
    private BigDecimal totalBudget;
    private PlanningMode planningMode;
    private Long templateId;
    private Boolean isCustomized;
    private TripStatus tripStatus;
    private String inviteCode;
}
