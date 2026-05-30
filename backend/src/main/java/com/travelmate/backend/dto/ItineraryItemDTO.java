package com.travelmate.backend.dto;

import lombok.*;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.math.BigDecimal;
import com.travelmate.backend.entity.enums.SourceType;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ItineraryItemDTO {
    private Long id;
    private Long tripId;
    private Long placeId;
    private Integer dayNumber;
    private LocalTime startTime;
    private Integer duration;
    private String note;
    private BigDecimal costEstimate;
    private Integer orderIndex;
    private SourceType sourceType;
    private Boolean isLocked;
    private String customType;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
