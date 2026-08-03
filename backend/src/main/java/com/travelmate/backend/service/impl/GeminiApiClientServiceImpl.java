package com.travelmate.backend.service.impl;

import com.travelmate.backend.entity.AIMessage;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Service
public class GeminiApiClientServiceImpl {

    @Value("${gemini.api-key}")
    private String apiKey;

    @Value("${gemini.url}")
    private String geminiUrl;

    private final RestTemplate restTemplate = new RestTemplate();

    public String callGeminiApi(String systemInstruction, List<AIMessage> history, String userPrompt) {
        // Construct prompt payload with system instruction & context
        StringBuilder fullPrompt = new StringBuilder();
        fullPrompt.append("SYSTEM INSTRUCTION: ").append(systemInstruction).append("\n\n");

        for (AIMessage msg : history) {
            fullPrompt.append(msg.getSenderType()).append(": ").append(msg.getContent()).append("\n");
        }
        fullPrompt.append("USER: ").append(userPrompt).append("\nAI:");

        // Request Body Format for Gemini REST API
        Map<String, Object> textPart = Map.of("text", fullPrompt.toString());
        Map<String, Object> parts = Map.of("parts", List.of(textPart));
        Map<String, Object> body = Map.of("contents", List.of(parts));

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        HttpEntity<Map<String, Object>> requestEntity = new HttpEntity<>(body, headers);
        String url = geminiUrl + "?key=" + apiKey;

        try {
            ResponseEntity<Map> response = restTemplate.postForEntity(url, requestEntity, Map.class);
            return parseResponse(response.getBody());
        } catch (Exception e) {
            return "I am currently having trouble reaching my travel intelligence server. Please try again shortly!";
        }
    }

    private String parseResponse(Map body) {
        try {
            List candidates = (List) body.get("candidates");
            Map candidate = (Map) candidates.get(0);
            Map content = (Map) candidate.get("content");
            List parts = (List) content.get("parts");
            Map part = (Map) parts.get(0);
            return (String) part.get("text");
        } catch (Exception e) {
            return "Sorry, I could not process that recommendation right now.";
        }
    }
}