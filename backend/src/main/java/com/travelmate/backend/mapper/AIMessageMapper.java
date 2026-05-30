package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.AIMessageDTO;
import com.travelmate.backend.entity.AIMessage;

public class AIMessageMapper {
    public static AIMessageDTO toDto(AIMessage m) {
        if (m == null)
            return null;
        return AIMessageDTO.builder()
                .id(m.getId())
                .conversationId(m.getConversation() != null ? m.getConversation().getId() : null)
                .senderType(m.getSenderType())
                .content(m.getContent())
                .messageType(m.getMessageType())
                .tokenUsed(m.getTokenUsed())
                .modelName(m.getModelName())
                .responseTimeMs(m.getResponseTimeMs())
                .contextData(m.getContextData())
                .confidenceScore(m.getConfidenceScore())
                .createdAt(m.getCreatedAt())
                .build();
    }
}
