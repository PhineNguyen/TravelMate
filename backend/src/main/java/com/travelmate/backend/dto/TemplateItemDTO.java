package com.travelmate.backend.dto;

import java.time.LocalTime;

import lombok.*;

@Data
@AllArgsConstructor
@Builder
public class TemplateItemDTO {
    private Long id;
    private Long templateId;
    private Long placeId;
    private Integer dayNumber;
    private Integer orderIndex;
    private LocalTime startTime;
    private Integer duration;
    private String note;
    private boolean isOptional;
}
