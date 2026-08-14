package com.travelmate.backend.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AIConversationUpdateRequest {

    @NotBlank(message = "sessionTitle must not be blank")
    private String sessionTitle;
}
