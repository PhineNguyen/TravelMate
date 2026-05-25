package com.travelmate.backend.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.*;

@Data
@AllArgsConstructor
@Builder
public class TripTemplateDTO {
    private Long id;
    private String title;
    private String destination;
    private String category;
    private Integer duration;
    private BigDecimal estimatedBudget;
    private String thumbnailUrl;
    private String description;
    private Double popularityScore;
    private LocalDateTime createdAt;

}
