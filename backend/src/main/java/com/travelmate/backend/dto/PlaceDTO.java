package com.travelmate.backend.dto;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import com.travelmate.backend.entity.enums.ExpenseCategory;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class PlaceDTO {
    private Long id;
    private String name;
    private String description;
    private Double latitude;
    private Double longitude;
    private String address;
    private String city;
    private String country;
    private ExpenseCategory category;
    private Double rating;
    private Integer reviewCount;
    private BigDecimal avgCost;
    private String currency;
    private Boolean isIndoor;
    private Boolean isActive;
    private String imageUrl;
    private String phoneNumber;
    private String websiteUrl;
    private String sourceProvider;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
