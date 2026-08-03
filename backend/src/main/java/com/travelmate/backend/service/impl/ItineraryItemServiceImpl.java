package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.ItineraryItemDTO;
import com.travelmate.backend.entity.ItineraryItem;
import com.travelmate.backend.entity.Place;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.repository.ItineraryItemRepository;
import com.travelmate.backend.repository.PlaceRepository;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.service.ItineraryItemService;
import com.travelmate.backend.mapper.ItineraryItemMapper;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ItineraryItemServiceImpl implements ItineraryItemService {

    private final ItineraryItemRepository itineraryItemRepository;
    private final TripRepository tripRepository;
    private final PlaceRepository placeRepository;

    @Override
    @Transactional
    public ItineraryItemDTO create(ItineraryItemDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("ItineraryItemDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getTripId() == null)
            throw new IllegalArgumentException("tripId is required");
        if (dto.getDayNumber() == null)
            throw new IllegalArgumentException("dayNumber is required");
        if (dto.getOrderIndex() == null)
            throw new IllegalArgumentException("orderIndex is required");

        Trip trip = tripRepository.findById(dto.getTripId())
                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));
        Place place = null;
        if (dto.getPlaceId() != null)
            place = placeRepository.findById(dto.getPlaceId())
                    .orElseThrow(() -> new IllegalArgumentException("Place not found"));

        ItineraryItem it = ItineraryItem.builder()
                .trip(trip)
                .place(place)
                .dayNumber(dto.getDayNumber())
                .startTime(dto.getStartTime())
                .duration(dto.getDuration())
                .note(dto.getNote())
                .costEstimate(
                        dto.getCostEstimate() != null ? dto.getCostEstimate().setScale(2, BigDecimal.ROUND_HALF_UP)
                                : null)
                .orderIndex(dto.getOrderIndex())
                .sourceType(dto.getSourceType())
                .isLocked(dto.getIsLocked() != null ? dto.getIsLocked() : false)
                .customType(dto.getCustomType())
                .build();

        try {
            return ItineraryItemMapper.toDto(itineraryItemRepository.save(it));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public ItineraryItemDTO update(ItineraryItemDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("ItineraryItemDTO must not be null");
        if (dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");

        ItineraryItem existing = itineraryItemRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("ItineraryItem not found"));

        if (dto.getPlaceId() != null)
            existing.setPlace(placeRepository.findById(dto.getPlaceId())
                    .orElseThrow(() -> new IllegalArgumentException("Place not found")));
        if (dto.getDayNumber() != null)
            existing.setDayNumber(dto.getDayNumber());
        if (dto.getStartTime() != null)
            existing.setStartTime(dto.getStartTime());
        if (dto.getDuration() != null)
            existing.setDuration(dto.getDuration());
        if (dto.getNote() != null)
            existing.setNote(dto.getNote());
        if (dto.getCostEstimate() != null)
            existing.setCostEstimate(dto.getCostEstimate().setScale(2, BigDecimal.ROUND_HALF_UP));
        if (dto.getOrderIndex() != null)
            existing.setOrderIndex(dto.getOrderIndex());
        if (dto.getSourceType() != null)
            existing.setSourceType(dto.getSourceType());
        if (dto.getIsLocked() != null)
            existing.setLocked(dto.getIsLocked());
        if (dto.getCustomType() != null)
            existing.setCustomType(dto.getCustomType());

        try {
            return ItineraryItemMapper.toDto(itineraryItemRepository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public ItineraryItemDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return itineraryItemRepository.findById(id).map(ItineraryItemMapper::toDto).orElse(null);
    }

    @Override
    public List<ItineraryItemDTO> listAll() {
        return itineraryItemRepository.findAll().stream().map(ItineraryItemMapper::toDto).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!itineraryItemRepository.existsById(id))
            throw new IllegalArgumentException("ItineraryItem not found");
        itineraryItemRepository.deleteById(id);
    }

}
