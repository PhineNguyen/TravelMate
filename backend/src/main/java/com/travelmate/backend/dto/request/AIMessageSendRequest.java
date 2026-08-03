package com.travelmate.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AIMessageSendRequest {

    @NotNull(message = "conversationId is required")
    private Long conversationId;

    @NotBlank(message = "content must not be blank")
    private String content;
}