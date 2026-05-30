package com.travelmate.backend.service.impl;

import com.travelmate.backend.entity.TripTemplate;

import com.travelmate.backend.dto.TripTemplateDTO;

import com.travelmate.backend.repository.TripTemplateRepository;

import com.travelmate.backend.service.TripTemplateService;
import com.travelmate.backend.mapper.TripTemplateMapper;

import jakarta.transaction.Transactional;

import java.math.RoundingMode;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TripTemplateServiceImpl implements TripTemplateService {
    private final TripTemplateRepository tripTemplateRepository;

    @Override
    @Transactional
    public TripTemplateDTO create(TripTemplateDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("TripTemplateDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("Id must not be null");

        if (TripTemplateMapper.trimToNull(dto.getTitle()) == null) {
            throw new IllegalArgumentException("Title is required");
        }
        if (TripTemplateMapper.trimToNull(dto.getDestination()) == null) {
            throw new IllegalArgumentException("Destination is required");
        }

        TripTemplate entity = new TripTemplate();
        TripTemplateMapper.applyDtoToEntity(dto, entity);
        try {
            TripTemplate saved = tripTemplateRepository.save(entity);

            return TripTemplateMapper.toDto(saved);
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database contraint violated", ex);
        }
    }

    @Override
    @Transactional
    public TripTemplateDTO update(TripTemplateDTO dto) {
        if (dto == null) {
            throw new IllegalArgumentException("TripTemplateDTO must not be null");
        }
        if (dto.getId() == null) {
            throw new IllegalArgumentException("Id is required when update");
        }

        TripTemplate existing = tripTemplateRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("TripTemplate Id not found"));
        TripTemplateMapper.applyDtoToEntity(dto, existing);

        try {
            TripTemplate saved = tripTemplateRepository.save(existing);
            return TripTemplateMapper.toDto(saved);
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database contraint violiation", ex);
        }
    }

    @Override
    public TripTemplateDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("Id is required");
        return tripTemplateRepository.findById(id).map(TripTemplateMapper::toDto).orElse(null);
    }

    @Override
    public List<TripTemplateDTO> listAll() {
        return tripTemplateRepository.findAll()
                .stream()
                .map(TripTemplateMapper::toDto)
                .collect(Collectors.toList());

    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id is required");
        }
        if (!tripTemplateRepository.existsById(id))
            throw new IllegalArgumentException("TripTemplate not found");
        tripTemplateRepository.deleteById(id);
    }

}
