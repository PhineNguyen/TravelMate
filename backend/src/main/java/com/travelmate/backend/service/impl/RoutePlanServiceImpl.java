package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.RoutePlanDTO;
import com.travelmate.backend.entity.RoutePlan;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.repository.RoutePlanRepository;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.service.RoutePlanService;
import com.travelmate.backend.mapper.RoutePlanMapper;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RoutePlanServiceImpl implements RoutePlanService {

    private final RoutePlanRepository repository;
    private final TripRepository tripRepository;

    @Override
    @Transactional
    public RoutePlanDTO create(RoutePlanDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("RoutePlanDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getTripId() == null)
            throw new IllegalArgumentException("tripId is required");
        if (dto.getStrategyType() == null)
            throw new IllegalArgumentException("strategyType is required");

        Trip trip = tripRepository.findById(dto.getTripId())
                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));

        RoutePlan r = RoutePlan.builder()
                .trip(trip)
                .strategyType(dto.getStrategyType())
                .totalDistance(dto.getTotalDistance())
                .estimatedDuration(dto.getEstimatedDuration())
                .routeScore(dto.getRouteScore())
                .build();

        try {
            return RoutePlanMapper.toDto(repository.save(r));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public RoutePlanDTO update(RoutePlanDTO dto) {
        if (dto == null || dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");
        RoutePlan existing = repository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("RoutePlan not found"));
        if (dto.getTotalDistance() != null)
            existing.setTotalDistance(dto.getTotalDistance());
        if (dto.getEstimatedDuration() != null)
            existing.setEstimatedDuration(dto.getEstimatedDuration());
        if (dto.getRouteScore() != null)
            existing.setRouteScore(dto.getRouteScore());

        try {
            return RoutePlanMapper.toDto(repository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public RoutePlanDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return repository.findById(id).map(RoutePlanMapper::toDto).orElse(null);
    }

    @Override
    public List<RoutePlanDTO> listAll() {
        return repository.findAll().stream().map(RoutePlanMapper::toDto).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!repository.existsById(id))
            throw new IllegalArgumentException("RoutePlan not found");
        repository.deleteById(id);
    }

}
