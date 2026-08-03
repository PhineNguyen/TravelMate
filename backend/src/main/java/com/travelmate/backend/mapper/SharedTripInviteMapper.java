package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.SharedTripInviteDTO;
import com.travelmate.backend.entity.SharedTripInvite;

public class SharedTripInviteMapper {
    public static SharedTripInviteDTO toDto(SharedTripInvite s) {
        if (s == null)
            return null;
        return SharedTripInviteDTO.builder()
                .id(s.getId())
                .tripId(s.getTrip() != null ? s.getTrip().getId() : null)
                .senderId(s.getSender() != null ? s.getSender().getId() : null)
                .receiverEmail(s.getReceiverEmail())
                .inviteCode(s.getInviteCode())
                .status(s.getStatus())
                .expiresAt(s.getExpiresAt())
                .createdAt(s.getCreatedAt())
                .build();
    }
}
