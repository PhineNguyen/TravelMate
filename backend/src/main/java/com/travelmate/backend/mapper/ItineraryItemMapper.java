package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.ItineraryItemDTO;
import com.travelmate.backend.entity.ItineraryItem;

public class ItineraryItemMapper {
    public static ItineraryItemDTO toDto(ItineraryItem i) {
        if (i == null)
            return null;
        return ItineraryItemDTO.builder()
                .id(i.getId())
                .tripId(i.getTrip() != null ? i.getTrip().getId() : null)
                .placeId(i.getPlace() != null ? i.getPlace().getId() : null)
                .dayNumber(i.getDayNumber())
                .startTime(i.getStartTime())
                .duration(i.getDuration())
                .note(i.getNote())
                .costEstimate(i.getCostEstimate())
                .orderIndex(i.getOrderIndex())
                .sourceType(i.getSourceType())
                .isLocked(i.isLocked())
                .customType(i.getCustomType())
                .createdAt(i.getCreatedAt())
                .updatedAt(i.getUpdatedAt())
                .build();
    }
}
