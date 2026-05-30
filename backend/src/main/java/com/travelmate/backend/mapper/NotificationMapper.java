package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.NotificationDTO;
import com.travelmate.backend.entity.Notification;

public class NotificationMapper {
    public static NotificationDTO toDto(Notification n) {
        if (n == null)
            return null;
        return NotificationDTO.builder()
                .id(n.getId())
                .userId(n.getUser() != null ? n.getUser().getId() : null)
                .title(n.getTitle())
                .body(n.getBody())
                .type(n.getType())
                .isRead(n.isRead())
                .createdAt(n.getCreatedAt())
                .build();
    }
}
