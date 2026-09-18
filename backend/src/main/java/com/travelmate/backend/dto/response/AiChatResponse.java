package com.travelmate.backend.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Map;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AiChatResponse {
    private String reply;
    private String intent;

    @JsonProperty("structured_data")
    private Map<String, Object> structuredData;
}
