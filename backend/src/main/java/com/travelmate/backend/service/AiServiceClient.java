package com.travelmate.backend.service;

public interface AiServiceClient {
    String getChatReply(String sessionId, String message);
    void deleteChatHistory(String sessionId);
}
