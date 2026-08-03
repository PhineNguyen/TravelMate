package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.ChatRoomDTO;
import com.travelmate.backend.entity.ChatRoom;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.repository.ChatRoomRepository;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.service.ChatRoomService;
import com.travelmate.backend.mapper.ChatRoomMapper;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ChatRoomServiceImpl implements ChatRoomService {

    private final ChatRoomRepository chatRoomRepository;
    private final TripRepository tripRepository;

    @Override
    @Transactional
    public ChatRoomDTO create(ChatRoomDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("ChatRoomDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");

        Trip trip = null;
        if (dto.getTripId() != null) {
            trip = tripRepository.findById(dto.getTripId())
                    .orElseThrow(() -> new IllegalArgumentException("Trip not found"));
        }

        if (trip != null && chatRoomRepository.existsByTripId(trip.getId()))
            throw new IllegalArgumentException("ChatRoom already exists for this trip");

        ChatRoom room = ChatRoom.builder().trip(trip).build();
        try {
            return ChatRoomMapper.toDto(chatRoomRepository.save(room));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public ChatRoomDTO update(ChatRoomDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("ChatRoomDTO must not be null");
        if (dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");

        ChatRoom existing = chatRoomRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("ChatRoom not found"));

        if (dto.getTripId() != null
                && (existing.getTrip() == null || !dto.getTripId().equals(existing.getTrip().getId()))) {
            Trip trip = tripRepository.findById(dto.getTripId())
                    .orElseThrow(() -> new IllegalArgumentException("Trip not found"));
            existing.setTrip(trip);
        }

        try {
            return ChatRoomMapper.toDto(chatRoomRepository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public ChatRoomDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return chatRoomRepository.findById(id).map(ChatRoomMapper::toDto).orElse(null);
    }

    @Override
    public List<ChatRoomDTO> listAll() {
        return chatRoomRepository.findAll().stream().map(ChatRoomMapper::toDto).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!chatRoomRepository.existsById(id))
            throw new IllegalArgumentException("ChatRoom not found");
        chatRoomRepository.deleteById(id);
    }

}
