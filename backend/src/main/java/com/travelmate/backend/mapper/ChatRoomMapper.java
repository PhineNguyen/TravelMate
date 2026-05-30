package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.ChatRoomDTO;
import com.travelmate.backend.entity.ChatRoom;

public class ChatRoomMapper {
    public static ChatRoomDTO toDto(ChatRoom r) {
        if (r == null)
            return null;
        return ChatRoomDTO.builder()
                .id(r.getId())
                .tripId(r.getTrip() != null ? r.getTrip().getId() : null)
                .createdAt(r.getCreatedAt())
                .build();
    }
}
