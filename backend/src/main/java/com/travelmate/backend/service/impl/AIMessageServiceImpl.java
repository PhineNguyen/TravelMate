package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.AIMessageDTO;
import com.travelmate.backend.entity.AIMessage;
import com.travelmate.backend.mapper.AIMessageMapper;
import com.travelmate.backend.entity.AIConversation;
import com.travelmate.backend.repository.AIMessageRepository;
import com.travelmate.backend.repository.AIConversationRepository;
import com.travelmate.backend.service.AIMessageService;

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
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!aiMessageRepository.existsById(id))
            throw new IllegalArgumentException("Message not found");
        aiMessageRepository.deleteById(id);
    }

}
