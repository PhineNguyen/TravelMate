package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.AIConversationDTO;
import com.travelmate.backend.mapper.AIConversationMapper;
import com.travelmate.backend.entity.AIConversation;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.repository.AIConversationRepository;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.service.AIConversationService;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AIConversationServiceImpl implements AIConversationService {

    private final AIConversationRepository aiConversationRepository;
    private final UserRepository userRepository;
    private final TripRepository tripRepository;

    @Override
    @Transactional
    public AIConversationDTO create(AIConversationDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("AIConversationDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getUserId() == null)
            throw new IllegalArgumentException("userId is required");

        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        Trip trip = null;
        if (dto.getTripId() != null) {
            trip = tripRepository.findById(dto.getTripId())
                    .orElseThrow(() -> new IllegalArgumentException("Trip not found"));
        }

        AIConversation entity = AIConversation.builder()
                .user(user)
                .trip(trip)
                .sessionTitle(dto.getSessionTitle())
                .build();

        try {
            return AIConversationMapper.toDto(aiConversationRepository.save(entity));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public AIConversationDTO update(AIConversationDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("AIConversationDTO must not be null");
        if (dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");

        AIConversation existing = aiConversationRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("Conversation not found"));

        if (dto.getSessionTitle() != null)
            existing.setSessionTitle(dto.getSessionTitle());

        try {
            return AIConversationMapper.toDto(aiConversationRepository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public AIConversationDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return aiConversationRepository.findById(id).map(AIConversationMapper::toDto).orElse(null);
    }

    @Override
    public List<AIConversationDTO> listAll() {
        return aiConversationRepository.findAll().stream().map(AIConversationMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!aiConversationRepository.existsById(id))
            throw new IllegalArgumentException("Conversation not found");
        aiConversationRepository.deleteById(id);
    }

}
