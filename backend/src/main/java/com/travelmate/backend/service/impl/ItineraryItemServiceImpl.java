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
    private final com.travelmate.backend.security.ResourceAccess access;

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
        access.trip(dto.getTripId());
        if (dto.getDayNumber() < 1 || dto.getOrderIndex() < 0) throw new IllegalArgumentException("Invalid day/order");
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

        access.trip(existing.getTrip().getId());
        if (dto.getPlaceId() != null)
            existing.setPlace(placeRepository.findById(dto.getPlaceId())
                    .orElseThrow(() -> new IllegalArgumentException("Place not found")));
        if (dto.getDayNumber() != null && dto.getDayNumber() < 1) throw new IllegalArgumentException("Invalid day");
        if (dto.getOrderIndex() != null && dto.getOrderIndex() < 0) throw new IllegalArgumentException("Invalid order");
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
        ItineraryItem item = itineraryItemRepository.findById(id).orElseThrow(() -> new java.util.NoSuchElementException("Item not found"));
        access.trip(item.getTrip().getId());
        return ItineraryItemMapper.toDto(item);
    }

    @Override
    public List<ItineraryItemDTO> listAll() {
        return itineraryItemRepository.findAll().stream().map(ItineraryItemMapper::toDto).collect(Collectors.toList());
    }

    @Override
    public List<ItineraryItemDTO> findByTripId(Long tripId) {
        if (tripId == null) {
            throw new IllegalArgumentException("tripId is required");
        }
        access.trip(tripId);
        return itineraryItemRepository.findByTripIdOrderByDayNumberAscOrderIndexAsc(tripId)
                .stream()
                .map(ItineraryItemMapper::toDto)
                .collect(Collectors.toList());
    }
    @Transactional
    public void reorder(List<ItineraryItemDTO> items) {
        if (items == null || items.isEmpty()) throw new IllegalArgumentException("Items are required");
        java.util.Set<Long> ids = new java.util.HashSet<>();
        Long tripId = null;
        for (ItineraryItemDTO dto : items) {
            if (dto == null || dto.getId() == null || !ids.add(dto.getId())
                    || dto.getDayNumber() == null || dto.getDayNumber() < 1
                    || dto.getOrderIndex() == null || dto.getOrderIndex() < 0)
                throw new IllegalArgumentException("Invalid reorder item");
            // Lấy điểm đến từ DB và chỉ cập nhật lại Ngày + Số thứ tự
            ItineraryItem item = itineraryItemRepository.findById(dto.getId())
                    .orElseThrow(() -> new IllegalArgumentException("Không tìm thấy ItineraryItem"));
            access.trip(item.getTrip().getId());
            if (tripId != null && !tripId.equals(item.getTrip().getId()))
                throw new IllegalArgumentException("Cannot reorder multiple trips");
            tripId = item.getTrip().getId();
            item.setDayNumber(dto.getDayNumber());
            item.setOrderIndex(dto.getOrderIndex());
            
            // Vì có annotation @Transactional, Hibernate sẽ tự động lưu các thay đổi này xuống DB
        }
    }
    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!itineraryItemRepository.existsById(id))
            throw new IllegalArgumentException("ItineraryItem not found");
        findById(id);
        itineraryItemRepository.deleteById(id);
    }

}
