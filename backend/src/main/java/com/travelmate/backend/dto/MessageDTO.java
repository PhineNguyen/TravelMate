package com.travelmate.backend.dto;

import lombok.*;
import java.time.LocalDateTime;
import com.travelmate.backend.entity.enums.MessageType;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MessageDTO {
    private Long id;
    private Long roomId;
    private Long senderId;
    private String content;
    private MessageType messageType;
    private LocalDateTime createdAt;
    private boolean isEdited;
    private LocalDateTime editedAt;
    private boolean isDeleted;
    private String attachmentUrl;
}
