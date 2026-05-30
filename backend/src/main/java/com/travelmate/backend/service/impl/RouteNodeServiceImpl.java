package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.RouteNodeDTO;
import com.travelmate.backend.entity.Place;
import com.travelmate.backend.entity.RouteNode;
import com.travelmate.backend.entity.RoutePlan;
import com.travelmate.backend.repository.PlaceRepository;
import com.travelmate.backend.repository.RouteNodeRepository;
import com.travelmate.backend.repository.RoutePlanRepository;
import com.travelmate.backend.service.RouteNodeService;
import com.travelmate.backend.mapper.RouteNodeMapper;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RouteNodeServiceImpl implements RouteNodeService {

    private final RouteNodeRepository repository;
    private final RoutePlanRepository routePlanRepository;
    private final PlaceRepository placeRepository;

    @Override
    @Transactional
    public RouteNodeDTO create(RouteNodeDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("RouteNodeDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getRoutePlanId() == null)
            throw new IllegalArgumentException("routePlanId is required");
        if (dto.getSequenceOrder() == null)
            throw new IllegalArgumentException("sequenceOrder is required");

        RoutePlan plan = routePlanRepository.findById(dto.getRoutePlanId())
                .orElseThrow(() -> new IllegalArgumentException("RoutePlan not found"));
        Place place = null;
        if (dto.getPlaceId() != null)
            place = placeRepository.findById(dto.getPlaceId())
                    .orElseThrow(() -> new IllegalArgumentException("Place not found"));

        if (repository.existsByRoutePlanIdAndSequenceOrder(dto.getRoutePlanId(), dto.getSequenceOrder())) {
            throw new IllegalArgumentException("RouteNode with same sequence already exists for plan");
        }

        RouteNode n = RouteNode.builder()
                .routePlan(plan)
                .place(place)
                .sequenceOrder(dto.getSequenceOrder())
                .arrivalTime(dto.getArrivalTime())
                .departureTime(dto.getDepartureTime())
                .travelMinutes(dto.getTravelMinutes())
                .build();

        try {
            return RouteNodeMapper.toDto(repository.save(n));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public RouteNodeDTO update(RouteNodeDTO dto) {
        if (dto == null || dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");
        RouteNode existing = repository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("RouteNode not found"));
        if (dto.getPlaceId() != null)
            existing.setPlace(placeRepository.findById(dto.getPlaceId())
                    .orElseThrow(() -> new IllegalArgumentException("Place not found")));
        if (dto.getSequenceOrder() != null)
            existing.setSequenceOrder(dto.getSequenceOrder());
        if (dto.getArrivalTime() != null)
            existing.setArrivalTime(dto.getArrivalTime());
        if (dto.getDepartureTime() != null)
            existing.setDepartureTime(dto.getDepartureTime());
        if (dto.getTravelMinutes() != null)
            existing.setTravelMinutes(dto.getTravelMinutes());

        try {
            return RouteNodeMapper.toDto(repository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public RouteNodeDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return repository.findById(id).map(RouteNodeMapper::toDto).orElse(null);
    }

    @Override
    public List<RouteNodeDTO> listAll() {
        return repository.findAll().stream().map(RouteNodeMapper::toDto).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!repository.existsById(id))
            throw new IllegalArgumentException("RouteNode not found");
        repository.deleteById(id);
    }

}
