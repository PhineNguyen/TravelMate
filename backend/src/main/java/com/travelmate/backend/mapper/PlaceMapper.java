package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.PlaceDTO;
import com.travelmate.backend.entity.Place;

public class PlaceMapper {
    public static PlaceDTO toDto(Place p) {
        if (p == null)
            return null;
        return PlaceDTO.builder()
                .id(p.getId())
                .name(p.getName())
                .description(p.getDescription())
                .latitude(p.getLatitude())
                .longitude(p.getLongitude())
                .address(p.getAddress())
                .city(p.getCity())
                .country(p.getCountry())
                .category(p.getCategory())
                .rating(p.getRating())
                .reviewCount(p.getReviewCount())
                .avgCost(p.getAvgCost())
                .currency(p.getCurrency())
                .isIndoor(p.isIndoor())
                .isActive(p.isActive())
                .imageUrl(p.getImageUrl())
                .phoneNumber(p.getPhoneNumber())
                .websiteUrl(p.getWebsiteUrl())
                .sourceProvider(p.getSourceProvider())
                .createdAt(p.getCreatedAt())
                .updatedAt(p.getUpdatedAt())
                .build();
    }
}
