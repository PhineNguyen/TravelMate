package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.UserPreferenceDTO;
import com.travelmate.backend.entity.UserPreference;

public class UserPreferenceMapper {
    public static UserPreferenceDTO toDto(UserPreference p) {
        if (p == null)
            return null;
        return UserPreferenceDTO.builder()
                .id(p.getId())
                .userId(p.getUser() != null ? p.getUser().getId() : null)
                .minBudget(p.getMinBudget())
                .maxBudget(p.getMaxBudget())
                .avgTripDays(p.getAvgTripDays())
                .preferredStyle(p.getPreferredStyle())
                .favoriteCategories(p.getFavoriteCategories())
                .preferredRegion(p.getPreferredRegion())
                .build();
    }
}
