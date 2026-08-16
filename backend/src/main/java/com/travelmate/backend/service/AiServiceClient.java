package com.travelmate.backend.service;

import com.travelmate.backend.dto.response.AiItineraryGenerateResponse;
import java.util.List;

public interface AiServiceClient {
    String getChatReply(String sessionId, String message, String destination, String preferences);
    void deleteChatHistory(String sessionId);
    AiItineraryGenerateResponse generateItinerary(
        String destination,
        Integer durationDays,
        Double budget,
        String travelStyle,
        Integer travelerCount,
        List<String> preferences
    );
}
