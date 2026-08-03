package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.TripParticipantDTO;
import com.travelmate.backend.entity.TripParticipant;

public class TripParticipantMapper {
    public static TripParticipantDTO toDto(TripParticipant p) {
        if (p == null)
            return null;
        return TripParticipantDTO.builder()
                .id(p.getId())
                .tripId(p.getTrip() != null ? p.getTrip().getId() : null)
                .userId(p.getUser() != null ? p.getUser().getId() : null)
                .role(p.getRole())
                .joinedAt(p.getJoinedAt())
                .isActive(p.isActive())
                .build();
    }
}
