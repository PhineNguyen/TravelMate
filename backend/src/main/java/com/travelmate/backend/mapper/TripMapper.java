package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.response.TripResponse;
import com.travelmate.backend.entity.Trip;

public class TripMapper {
    public static TripResponse toResponse(Trip e) {
        if (e == null)
            return null;
        return TripResponse.builder()
                .id(e.getId())
                .ownerId(e.getOwner() != null ? e.getOwner().getId() : null)
                .destination(e.getDestination())
                .startDate(e.getStartDate())
                .duration(e.getDuration())
                .travelerCount(e.getTravelerCount())
                .totalBudget(e.getTotalBudget())
                .planningMode(e.getPlanningMode())
                .templateId(e.getTemplate() != null ? e.getTemplate().getId() : null)
                .isCustomized(e.isCustomized())
                .tripStatus(e.getTripStatus())
                .inviteCode(e.getInviteCode())
                .createdAt(e.getCreatedAt())
                .updatedAt(e.getUpdatedAt())
                .build();
    }
}
