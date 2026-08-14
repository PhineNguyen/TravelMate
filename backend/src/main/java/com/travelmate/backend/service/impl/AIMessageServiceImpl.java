package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.AIMessageDTO;
import com.travelmate.backend.entity.AIConversation;
import com.travelmate.backend.entity.AIMessage;
import com.travelmate.backend.entity.enums.SenderType;
import com.travelmate.backend.mapper.AIMessageMapper;
import com.travelmate.backend.repository.AIConversationRepository;
import com.travelmate.backend.repository.AIMessageRepository;
import com.travelmate.backend.service.AIMessageService;
import com.travelmate.backend.service.AiServiceClient;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AIMessageServiceImpl implements AIMessageService {

    private final AIMessageRepository aiMessageRepository;
    private final AIConversationRepository aiConversationRepository;
    private final AiServiceClient aiServiceClient;

    // Persona của TravelMate AI 
    private static final String TRAVEL_MATE_PERSONA = "You are TravelMate AI, an expert travel assistant. " +
            "Help users with itineraries, food recommendations, and travel advice concisely.";

    // =========================================================================
    // 🚀 PHƯƠNG THỨC MỚI: XỬ LÝ GỬI TIN NHẮN VÀ NHẬN PHẢN HỒI TỪ AI SERVICE
    // =========================================================================
    @Override
    @Transactional
    public AIMessageDTO sendMessage(Long conversationId, String userContent) {
        if (conversationId == null) {
            throw new IllegalArgumentException("conversationId is required");
        }
        if (userContent == null || userContent.trim().isEmpty()) {
            throw new IllegalArgumentException("userContent must not be empty");
        }

        // 1. Tìm cuộc hội thoại
        AIConversation conv = aiConversationRepository.findById(conversationId)
                .orElseThrow(() -> new IllegalArgumentException("Conversation not found with id: " + conversationId));

        // 2. Lưu tin nhắn của User vào PostgreSQL (Java Backend DB)
        AIMessage userMsg = AIMessage.builder()
                .conversation(conv)
                .senderType(SenderType.USER)
                .content(userContent)
                .build();
        aiMessageRepository.save(userMsg);

        // 3. Gọi API của ai-service để lấy câu trả lời (Phiên chat tự động quản lý lịch sử ở phía ai-service)
        String aiReplyText = aiServiceClient.getChatReply("conversation_" + conversationId, userContent);

        // 4. Lưu tin nhắn phản hồi của AI vào PostgreSQL (Java Backend DB)
        AIMessage aiMsg = AIMessage.builder()
                .conversation(conv)
                .senderType(SenderType.AI)
                .content(aiReplyText)
                .build();
        AIMessage savedAiMsg = aiMessageRepository.save(aiMsg);

        // 5. Trả về DTO câu trả lời của AI
        return AIMessageMapper.toDto(savedAiMsg);
    }

    // =========================================================================
    // CÁC HÀM CRUD SẴN CÓ
    // =========================================================================
    @Override
    @Transactional
    public AIMessageDTO create(AIMessageDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("AIMessageDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getConversationId() == null)
            throw new IllegalArgumentException("conversationId is required");

        AIConversation conv = aiConversationRepository.findById(dto.getConversationId())
                .orElseThrow(() -> new IllegalArgumentException("Conversation not found"));

        AIMessage m = AIMessage.builder()
                .conversation(conv)
                .senderType(dto.getSenderType())
                .content(dto.getContent())
                .messageType(dto.getMessageType())
                .tokenUsed(dto.getTokenUsed())
                .modelName(dto.getModelName())
                .responseTimeMs(dto.getResponseTimeMs())
                .contextData(dto.getContextData())
                .confidenceScore(dto.getConfidenceScore())
                .build();

        try {
            return AIMessageMapper.toDto(aiMessageRepository.save(m));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public AIMessageDTO update(AIMessageDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("AIMessageDTO must not be null");
        if (dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");

        AIMessage existing = aiMessageRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("Message not found"));

        if (dto.getContent() != null)
            existing.setContent(dto.getContent());
        if (dto.getMessageType() != null)
            existing.setMessageType(dto.getMessageType());
        if (dto.getTokenUsed() != null)
            existing.setTokenUsed(dto.getTokenUsed());
        if (dto.getModelName() != null)
            existing.setModelName(dto.getModelName());
        if (dto.getResponseTimeMs() != null)
            existing.setResponseTimeMs(dto.getResponseTimeMs());
        if (dto.getContextData() != null)
            existing.setContextData(dto.getContextData());
        if (dto.getConfidenceScore() != null)
            existing.setConfidenceScore(dto.getConfidenceScore());

        try {
            return AIMessageMapper.toDto(aiMessageRepository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public AIMessageDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return aiMessageRepository.findById(id).map(AIMessageMapper::toDto).orElse(null);
    }

    @Override
    public List<AIMessageDTO> listAll() {
        return aiMessageRepository.findAll().stream().map(AIMessageMapper::toDto).collect(Collectors.toList());
    }

    @Override
    @Transactional(readOnly = true)
    public List<AIMessageDTO> listByConversation(Long conversationId) {
        if (conversationId == null) {
            throw new IllegalArgumentException("conversationId is required");
        }
        return aiMessageRepository.findByConversationIdOrderByCreatedAtAsc(conversationId).stream()
                .map(AIMessageMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!aiMessageRepository.existsById(id))
            throw new IllegalArgumentException("Message not found");
        aiMessageRepository.deleteById(id);
    }
}