package com.travelmate.backend.dto.request;

import java.math.BigDecimal;
import java.time.LocalDate;
import com.travelmate.backend.entity.enums.PlanningMode;
import com.travelmate.backend.entity.enums.TripStatus;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
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

    @NotNull(message = "Owner ID is required")
    private Long ownerId;

    @NotBlank(message = "Destination is required")
    private String destination;

    @NotNull(message = "Start date is required")
    private LocalDate startDate;

    @NotNull(message = "Duration is required")
    @Min(value = 1, message = "Duration must be at least 1 day")
    private Integer duration;

    @NotNull(message = "Traveler count is required")
    @Min(value = 1, message = "Traveler count must be at least 1 person")
    private Integer travelerCount;

    private BigDecimal totalBudget;

    @NotNull(message = "Planning mode is required")
    private PlanningMode planningMode;

    private Long templateId;
    private Boolean isCustomized;
    private TripStatus tripStatus;
    private String inviteCode;
}