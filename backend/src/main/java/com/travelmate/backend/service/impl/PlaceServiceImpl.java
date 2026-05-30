package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.PlaceDTO;
import com.travelmate.backend.entity.Place;
import com.travelmate.backend.repository.PlaceRepository;
import com.travelmate.backend.service.PlaceService;
import com.travelmate.backend.mapper.PlaceMapper;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class PlaceServiceImpl implements PlaceService {

    private final PlaceRepository placeRepository;

    @Override
    @Transactional
    public PlaceDTO create(PlaceDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("PlaceDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");

        Place p = Place.builder()
                .name(dto.getName())
                .description(dto.getDescription())
                .latitude(dto.getLatitude())
                .longitude(dto.getLongitude())
                .address(dto.getAddress())
                .city(dto.getCity())
                .country(dto.getCountry())
                .category(dto.getCategory())
                .rating(dto.getRating())
                .reviewCount(dto.getReviewCount())
                .avgCost(dto.getAvgCost())
                .currency(dto.getCurrency())
                .isIndoor(dto.getIsIndoor() != null ? dto.getIsIndoor() : false)
                .isActive(dto.getIsActive() != null ? dto.getIsActive() : true)
                .imageUrl(dto.getImageUrl())
                .phoneNumber(dto.getPhoneNumber())
                .websiteUrl(dto.getWebsiteUrl())
                .sourceProvider(dto.getSourceProvider())
                .build();

        try {
            return PlaceMapper.toDto(placeRepository.save(p));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public PlaceDTO update(PlaceDTO dto) {
        if (dto == null || dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");
        Place existing = placeRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("Place not found"));
        if (dto.getName() != null)
            existing.setName(dto.getName());
        if (dto.getDescription() != null)
            existing.setDescription(dto.getDescription());
        if (dto.getLatitude() != null)
            existing.setLatitude(dto.getLatitude());
        if (dto.getLongitude() != null)
            existing.setLongitude(dto.getLongitude());
        if (dto.getAddress() != null)
            existing.setAddress(dto.getAddress());
        if (dto.getCity() != null)
            existing.setCity(dto.getCity());
        if (dto.getCountry() != null)
            existing.setCountry(dto.getCountry());
        if (dto.getCategory() != null)
            existing.setCategory(dto.getCategory());
        if (dto.getRating() != null)
            existing.setRating(dto.getRating());
        if (dto.getReviewCount() != null)
            existing.setReviewCount(dto.getReviewCount());
        if (dto.getAvgCost() != null)
            existing.setAvgCost(dto.getAvgCost());
        if (dto.getCurrency() != null)
            existing.setCurrency(dto.getCurrency());
        if (dto.getIsIndoor() != null)
            existing.setIndoor(dto.getIsIndoor());
        if (dto.getIsActive() != null)
            existing.setActive(dto.getIsActive());
        if (dto.getImageUrl() != null)
            existing.setImageUrl(dto.getImageUrl());
        if (dto.getPhoneNumber() != null)
            existing.setPhoneNumber(dto.getPhoneNumber());
        if (dto.getWebsiteUrl() != null)
            existing.setWebsiteUrl(dto.getWebsiteUrl());
        if (dto.getSourceProvider() != null)
            existing.setSourceProvider(dto.getSourceProvider());

        try {
            return PlaceMapper.toDto(placeRepository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public PlaceDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return placeRepository.findById(id).map(PlaceMapper::toDto).orElse(null);
    }

    @Override
    public List<PlaceDTO> listAll() {
        return placeRepository.findAll().stream().map(PlaceMapper::toDto).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!placeRepository.existsById(id))
            throw new IllegalArgumentException("Place not found");
        placeRepository.deleteById(id);
    }

}
