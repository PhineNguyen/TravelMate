package com.travelmate.backend.dto;

import lombok.*;
import java.time.LocalDateTime;
import com.travelmate.backend.entity.enums.NotificationType;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class NotificationDTO {
    private Long id;
    private Long userId;
    private String title;
    private String body;
    private NotificationType type;
    private Boolean isRead;
    private LocalDateTime createdAt;
}
