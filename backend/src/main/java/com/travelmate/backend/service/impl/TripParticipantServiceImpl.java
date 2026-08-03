package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.TripParticipantDTO;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.TripParticipant;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.repository.TripParticipantRepository;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.service.TripParticipantService;
import com.travelmate.backend.mapper.TripParticipantMapper;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TripParticipantServiceImpl implements TripParticipantService {

    private final TripParticipantRepository tripParticipantRepository;
    private final TripRepository tripRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public TripParticipantDTO create(TripParticipantDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("TripParticipantDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getTripId() == null)
            throw new IllegalArgumentException("tripId is required");
        if (dto.getUserId() == null)
            throw new IllegalArgumentException("userId is required");
        if (dto.getRole() == null)
            throw new IllegalArgumentException("role is required");

        Trip trip = tripRepository.findById(dto.getTripId())
                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));
        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (tripParticipantRepository.existsByTripIdAndUserId(dto.getTripId(), dto.getUserId())) {
            throw new IllegalArgumentException("Participant already exists for this trip and user");
        }

        TripParticipant p = TripParticipant.builder()
                .trip(trip)
                .user(user)
                .role(dto.getRole())
                .isActive(dto.getIsActive() != null ? dto.getIsActive() : true)
                .build();

        try {
            return TripParticipantMapper.toDto(tripParticipantRepository.save(p));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public TripParticipantDTO update(TripParticipantDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("TripParticipantDTO must not be null");
        if (dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");

        TripParticipant existing = tripParticipantRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("Participant not found"));

        if (dto.getRole() != null)
            existing.setRole(dto.getRole());
        if (dto.getIsActive() != null)
            existing.setActive(dto.getIsActive());

        try {
            return TripParticipantMapper.toDto(tripParticipantRepository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public TripParticipantDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return tripParticipantRepository.findById(id).map(TripParticipantMapper::toDto).orElse(null);
    }

    @Override
    public List<TripParticipantDTO> listAll() {
        return tripParticipantRepository.findAll().stream().map(TripParticipantMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        TripParticipant p = tripParticipantRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Participant not found"));
        // soft-delete
        p.setActive(false);
        tripParticipantRepository.save(p);
    }

}
