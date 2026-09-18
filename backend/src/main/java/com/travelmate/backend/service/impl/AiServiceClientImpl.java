package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.response.AiChatResponse;
import com.travelmate.backend.dto.response.AiItineraryGenerateResponse;
import com.travelmate.backend.service.AiServiceClient;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class AiServiceClientImpl implements AiServiceClient {

    @Value("${ai-service.url}")
    private String aiServiceUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    @Override
    public AiChatResponse chat(String sessionId, String message, String destination, String preferences) {
        String url = aiServiceUrl + "/ai/chat";

        Map<String, Object> body = new HashMap<>();
        body.put("session_id", sessionId);
        body.put("message", message);
        if (destination != null) {
            body.put("destination", destination);
        }
        if (preferences != null) {
            body.put("preferences", preferences);
        }

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<AiChatResponse> response = restTemplate.postForEntity(url, requestEntity, AiChatResponse.class);
            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                return response.getBody();
            }
            return AiChatResponse.builder()
                    .reply("Tôi gặp sự cố khi nhận phản hồi từ hệ thống AI (Mã lỗi: " + response.getStatusCode() + ")")
                    .intent("error")
                    .build();
        } catch (Exception e) {
            return AiChatResponse.builder()
                    .reply("Không thể kết nối đến máy chủ AI: " + e.getMessage())
                    .intent("error")
                    .build();
        }
    }

    @Override
    public String getChatReply(String sessionId, String message, String destination, String preferences) {
        AiChatResponse response = chat(sessionId, message, destination, preferences);
        return response != null ? response.getReply() : null;
    }

    @Override
    public void deleteChatHistory(String sessionId) {
        String url = aiServiceUrl + "/ai/chat/" + sessionId;
        try {
            restTemplate.delete(url);
        } catch (Exception e) {
            System.err.println("Warning: Could not clear AI session history for " + sessionId + ": " + e.getMessage());
        }
    }

    @Override
    public AiItineraryGenerateResponse generateItinerary(
        String destination,
        Integer durationDays,
        Double budget,
        String travelStyle,
        Integer travelerCount,
        List<String> preferences
    ) {
        String url = aiServiceUrl + "/ai/generate-itinerary";

        Map<String, Object> body = Map.of(
            "destination", destination != null ? destination : "",
            "duration_days", durationDays != null ? durationDays : 1,
            "budget", budget != null ? budget : 0.0,
            "travel_style", travelStyle != null ? travelStyle : "",
            "traveler_count", travelerCount != null ? travelerCount : 1,
            "preferences", preferences != null ? preferences : List.of()
        );

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(body, headers);

        try {
            ResponseEntity<AiItineraryGenerateResponse> response = restTemplate.postForEntity(
                url, requestEntity, AiItineraryGenerateResponse.class
            );
            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                return response.getBody();
            }
            throw new RuntimeException("AI Service returned status code: " + response.getStatusCode());
        } catch (Exception e) {
            throw new RuntimeException("Failed to generate itinerary with AI service: " + e.getMessage(), e);
        }
    }
}
