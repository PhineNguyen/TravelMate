package com.travelmate.backend.dto;

import java.math.BigDecimal;
import lombok.*;

@Data
@Builder
@AllArgsConstructor

public class UserPreferenceDTO {
    private Long id;
    private Long userId;
    private BigDecimal minBudget;
    private BigDecimal maxBudget;
    private Integer avgTripDays;
    private String preferredStyle;
    private String favoriteCategories;
    private String preferredRegion;

}
