package com.travelmate.backend.dto.response;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
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
public class TripResponse {
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
    private Boolean isDeleted;
    private LocalDateTime deleteAt;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
