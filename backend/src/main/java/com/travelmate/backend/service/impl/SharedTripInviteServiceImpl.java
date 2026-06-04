package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.SharedTripInviteDTO;
import com.travelmate.backend.entity.SharedTripInvite;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.repository.SharedTripInviteRepository;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.service.SharedTripInviteService;
import com.travelmate.backend.mapper.SharedTripInviteMapper;
import com.travelmate.backend.entity.enums.InviteStatus;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class SharedTripInviteServiceImpl implements SharedTripInviteService {

    private final SharedTripInviteRepository repository;
    private final TripRepository tripRepository;
    private final UserRepository userRepository;

    private String generateUniqueInviteCode() {
        String code;
        do {
            code = UUID.randomUUID().toString().replace("-", "").substring(0, 10).toUpperCase();
        } while (repository.existsByInviteCode(code));
        return code;
    }

    @Override
    @Transactional
    public SharedTripInviteDTO create(SharedTripInviteDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("SharedTripInviteDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getTripId() == null)
            throw new IllegalArgumentException("tripId is required");
        if (dto.getSenderId() == null)
            throw new IllegalArgumentException("senderId is required");
        if (dto.getReceiverEmail() == null)
            throw new IllegalArgumentException("receiverEmail is required");

        Trip trip = tripRepository.findByIdAndIsDeletedFalse(dto.getTripId())
                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));
        User sender = userRepository.findById(dto.getSenderId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        SharedTripInvite s = SharedTripInvite.builder()
                .trip(trip)
                .sender(sender)
                .receiverEmail(dto.getReceiverEmail())
                .inviteCode(dto.getInviteCode() != null ? dto.getInviteCode() : generateUniqueInviteCode())
                .status(dto.getStatus() != null ? dto.getStatus()
                        : InviteStatus.PENDING)
                .expiresAt(dto.getExpiresAt())
                .build();

        try {
            return SharedTripInviteMapper.toDto(repository.save(s));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public SharedTripInviteDTO update(SharedTripInviteDTO dto) {
        if (dto == null || dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");
        SharedTripInvite existing = repository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("SharedTripInvite not found"));
        if (dto.getReceiverEmail() != null)
            existing.setReceiverEmail(dto.getReceiverEmail());
        if (dto.getStatus() != null)
            applyStatusTransition(existing, dto.getStatus());
        if (dto.getExpiresAt() != null)
            existing.setExpiresAt(dto.getExpiresAt());

        try {
            return SharedTripInviteMapper.toDto(repository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public SharedTripInviteDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return repository.findById(id).map(SharedTripInviteMapper::toDto).orElse(null);
    }

    @Override
    public List<SharedTripInviteDTO> listAll() {
        return repository.findAll().stream().map(SharedTripInviteMapper::toDto).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!repository.existsById(id))
            throw new IllegalArgumentException("SharedTripInvite not found");
        SharedTripInvite existing = repository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("SharedTripInvite not found"));
        existing.setStatus(InviteStatus.REVOKED);
        repository.save(existing);
    }

    @Override
    @Transactional
    public SharedTripInviteDTO accept(Long id) {
        SharedTripInvite existing = getActiveInvite(id);
        applyStatusTransition(existing, InviteStatus.ACCEPTED);
        return SharedTripInviteMapper.toDto(repository.save(existing));
    }

    @Override
    @Transactional
    public SharedTripInviteDTO reject(Long id) {
        SharedTripInvite existing = getActiveInvite(id);
        applyStatusTransition(existing, InviteStatus.REJECTED);
        return SharedTripInviteMapper.toDto(repository.save(existing));
    }

    @Override
    @Transactional
    public SharedTripInviteDTO revoke(Long id) {
        SharedTripInvite existing = repository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("SharedTripInvite not found"));
        if (existing.getStatus() == InviteStatus.ACCEPTED) {
            throw new IllegalArgumentException("Accepted invitation cannot be revoked");
        }
        existing.setStatus(InviteStatus.REVOKED);
        return SharedTripInviteMapper.toDto(repository.save(existing));
    }

    private SharedTripInvite getActiveInvite(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        SharedTripInvite existing = repository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("SharedTripInvite not found"));
        if (existing.getStatus() == InviteStatus.EXPIRED || existing.getStatus() == InviteStatus.REVOKED) {
            throw new IllegalArgumentException("Invitation is no longer active");
        }
        if (existing.getExpiresAt() != null && existing.getExpiresAt().isBefore(java.time.LocalDateTime.now())) {
            existing.setStatus(InviteStatus.EXPIRED);
            repository.save(existing);
            throw new IllegalArgumentException("Invitation is expired");
        }
        if (existing.getStatus() != InviteStatus.PENDING) {
            throw new IllegalArgumentException("Invitation is no longer pending");
        }
        return existing;
    }

    private void applyStatusTransition(SharedTripInvite invite, InviteStatus next) {
        InviteStatus current = invite.getStatus();
        boolean allowed = current == InviteStatus.PENDING
                && (next == InviteStatus.ACCEPTED || next == InviteStatus.REJECTED
                        || next == InviteStatus.REVOKED || next == InviteStatus.EXPIRED);
        if (!allowed) {
            throw new IllegalArgumentException("Invalid invitation status transition");
        }
        invite.setStatus(next);
    }
}
