package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.MessageDTO;
import com.travelmate.backend.entity.Message;

public class MessageMapper {
    public static MessageDTO toDto(Message m) {
        if (m == null)
            return null;
        return MessageDTO.builder()
                .id(m.getId())
                .roomId(m.getRoom() != null ? m.getRoom().getId() : null)
                .senderId(m.getSender() != null ? m.getSender().getId() : null)
                .content(m.getContent())
                .messageType(m.getMessageType())
                .createdAt(m.getCreatedAt())
                .isEdited(m.isEdited())
                .editedAt(m.getEditedAt())
                .isDeleted(m.isDeleted())
                .attachmentUrl(m.getAttachmentUrl())
                .build();
    }
}
