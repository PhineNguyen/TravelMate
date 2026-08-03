package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.TemplateItemDTO;
import com.travelmate.backend.entity.Place;
import com.travelmate.backend.entity.TemplateItem;
import com.travelmate.backend.entity.TripTemplate;
import com.travelmate.backend.repository.PlaceRepository;
import com.travelmate.backend.repository.TemplateItemRepository;
import com.travelmate.backend.repository.TripTemplateRepository;
import com.travelmate.backend.service.TemplateItemService;
import com.travelmate.backend.mapper.TemplateItemMapper;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TemplateItemServiceImpl implements TemplateItemService {

    private final TemplateItemRepository repository;
    private final TripTemplateRepository templateRepository;
    private final PlaceRepository placeRepository;

    @Override
    @Transactional
    public TemplateItemDTO create(TemplateItemDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("TemplateItemDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getTemplateId() == null)
            throw new IllegalArgumentException("templateId is required");
        if (dto.getPlaceId() == null)
            throw new IllegalArgumentException("placeId is required");
        if (dto.getDayNumber() == null)
            throw new IllegalArgumentException("dayNumber is required");
        if (dto.getOrderIndex() == null)
            throw new IllegalArgumentException("orderIndex is required");

        TripTemplate template = templateRepository.findById(dto.getTemplateId())
                .orElseThrow(() -> new IllegalArgumentException("TripTemplate not found"));
        Place place = placeRepository.findById(dto.getPlaceId())
                .orElseThrow(() -> new IllegalArgumentException("Place not found"));

        if (repository.existsByTemplateIdAndDayNumberAndOrderIndex(dto.getTemplateId(), dto.getDayNumber(),
                dto.getOrderIndex())) {
            throw new IllegalArgumentException("Template item with same template/day/order already exists");
        }

        TemplateItem t = TemplateItem.builder()
                .template(template)
                .place(place)
                .dayNumber(dto.getDayNumber())
                .orderIndex(dto.getOrderIndex())
                .startTime(dto.getStartTime())
                .duration(dto.getDuration())
                .note(dto.getNote())
                .isOptional(dto.getIsOptional() != null ? dto.getIsOptional() : false)
                .build();

        try {
            return TemplateItemMapper.toDto(repository.save(t));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public TemplateItemDTO update(TemplateItemDTO dto) {
        if (dto == null || dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");
        TemplateItem existing = repository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("TemplateItem not found"));
        if (dto.getPlaceId() != null)
            existing.setPlace(placeRepository.findById(dto.getPlaceId())
                    .orElseThrow(() -> new IllegalArgumentException("Place not found")));
        if (dto.getDayNumber() != null)
            existing.setDayNumber(dto.getDayNumber());
        if (dto.getOrderIndex() != null)
            existing.setOrderIndex(dto.getOrderIndex());
        if (dto.getStartTime() != null)
            existing.setStartTime(dto.getStartTime());
        if (dto.getDuration() != null)
            existing.setDuration(dto.getDuration());
        if (dto.getNote() != null)
            existing.setNote(dto.getNote());
        if (dto.getIsOptional() != null)
            existing.setOptional(dto.getIsOptional());

        try {
            return TemplateItemMapper.toDto(repository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public TemplateItemDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return repository.findById(id).map(TemplateItemMapper::toDto).orElse(null);
    }

    @Override
    public List<TemplateItemDTO> listAll() {
        return repository.findAll().stream().map(TemplateItemMapper::toDto).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!repository.existsById(id))
            throw new IllegalArgumentException("TemplateItem not found");
        repository.deleteById(id);
    }

}
