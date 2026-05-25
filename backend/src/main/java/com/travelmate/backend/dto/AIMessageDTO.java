package com.travelmate.backend.dto;

import lombok.*;
import java.time.LocalDateTime;
import java.util.Map;
import com.travelmate.backend.entity.enums.SenderType;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AIMessageDTO {
    private Long id;
    private Long conversationId;
    private SenderType senderType;
    private String content;
    private String messageType;
    private Integer tokenUsed;
    private String modelName;
    private Long responseTimeMs;
    private Map<String, Object> contextData;
    private Double confidenceScore;
    private LocalDateTime createdAt;
}
