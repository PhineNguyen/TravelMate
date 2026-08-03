package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.ManualActionLogDTO;
import com.travelmate.backend.entity.ManualActionLog;
import com.travelmate.backend.entity.ItineraryItem;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.repository.ManualActionLogRepository;
import com.travelmate.backend.repository.ItineraryItemRepository;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.service.ManualActionLogService;
import com.travelmate.backend.mapper.ManualActionLogMapper;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ManualActionLogServiceImpl implements ManualActionLogService {

    private final ManualActionLogRepository manualActionLogRepository;
    private final TripRepository tripRepository;
    private final UserRepository userRepository;
    private final ItineraryItemRepository itineraryItemRepository;

    @Override
    @Transactional
    public ManualActionLogDTO create(ManualActionLogDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("ManualActionLogDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getTripId() == null)
            throw new IllegalArgumentException("tripId is required");
        if (dto.getUserId() == null)
            throw new IllegalArgumentException("userId is required");
        if (dto.getActionType() == null)
            throw new IllegalArgumentException("actionType is required");

        Trip trip = tripRepository.findById(dto.getTripId())
                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));
        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        ItineraryItem target = null;
        if (dto.getTargetItemId() != null)
            target = itineraryItemRepository.findById(dto.getTargetItemId()).orElse(null);

        ManualActionLog m = ManualActionLog.builder()
                .trip(trip)
                .user(user)
                .targetItem(target)
                .actionType(dto.getActionType())
                .build();

        try {
            return ManualActionLogMapper.toDto(manualActionLogRepository.save(m));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public ManualActionLogDTO update(ManualActionLogDTO dto) {
        throw new UnsupportedOperationException("Manual logs are append-only");
    }

    @Override
    public ManualActionLogDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return manualActionLogRepository.findById(id).map(ManualActionLogMapper::toDto).orElse(null);
    }

    @Override
    public List<ManualActionLogDTO> listAll() {
        return manualActionLogRepository.findAll().stream().map(ManualActionLogMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!manualActionLogRepository.existsById(id))
            throw new IllegalArgumentException("Log not found");
        manualActionLogRepository.deleteById(id);
    }

}
