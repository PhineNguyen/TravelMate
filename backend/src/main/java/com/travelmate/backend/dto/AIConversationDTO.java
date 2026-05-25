package com.travelmate.backend.dto;

import lombok.*;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AIConversationDTO {
    private Long id;
    private Long userId;
    private Long tripId;
    private String sessionTitle;
    private Integer messageCount;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
