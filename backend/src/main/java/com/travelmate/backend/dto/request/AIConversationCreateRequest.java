package com.travelmate.backend.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AIConversationCreateRequest {

    @NotNull(message = "userId is required")
    private Long userId;

    private Long tripId;

    private String sessionTitle;
}
