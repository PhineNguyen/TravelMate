package com.travelmate.backend.mapper;

import com.travelmate.backend.entity.AIConversation;
import com.travelmate.backend.dto.AIConversationDTO;

public class AIConversationMapper {
    public static AIConversationDTO toDto(AIConversation e) {
        if (e == null)
            return null;
        return AIConversationDTO.builder()
                .id(e.getId())
                .userId(e.getUser() != null ? e.getUser().getId() : null)
                .tripId(e.getTrip() != null ? e.getTrip().getId() : null)
                .sessionTitle(e.getSessionTitle())
                .messageCount(e.getMessages() != null ? e.getMessages().size() : 0)
                .createdAt(e.getCreatedAt())
                .updatedAt(e.getUpdatedAt())
                .build();
    }
}
