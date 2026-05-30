package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.WeatherAlertDTO;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.WeatherAlert;
import com.travelmate.backend.entity.WeatherSnapshot;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.repository.WeatherAlertRepository;
import com.travelmate.backend.repository.WeatherSnapshotRepository;
import com.travelmate.backend.service.WeatherAlertService;
import com.travelmate.backend.mapper.WeatherAlertMapper;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class WeatherAlertServiceImpl implements WeatherAlertService {

    private final WeatherAlertRepository weatherAlertRepository;
    private final TripRepository tripRepository;
    private final WeatherSnapshotRepository weatherSnapshotRepository;

    @Override
    @Transactional
    public WeatherAlertDTO create(WeatherAlertDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("WeatherAlertDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getTripId() == null)
            throw new IllegalArgumentException("tripId is required");
        if (dto.getSnapshotId() == null)
            throw new IllegalArgumentException("snapshotId is required");
        if (dto.getSeverity() == null)
            throw new IllegalArgumentException("severity is required");
        if (dto.getAlertType() == null)
            throw new IllegalArgumentException("alertType is required");

        Trip trip = tripRepository.findById(dto.getTripId())
                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));
        WeatherSnapshot snapshot = weatherSnapshotRepository.findById(dto.getSnapshotId())
                .orElseThrow(() -> new IllegalArgumentException("WeatherSnapshot not found"));

        boolean resolved = Boolean.TRUE.equals(dto.getIsResolved());
        WeatherAlert alert = WeatherAlert.builder()
                .trip(trip)
                .snapshot(snapshot)
                .severity(dto.getSeverity())
                .alertType(dto.getAlertType())
                .suggestedAction(trimToNull(dto.getSuggestedAction()))
                .isResolved(resolved)
                .resolvedAt(
                        resolved ? (dto.getResolvedAt() != null ? dto.getResolvedAt() : Instant.now()) : null)
                .build();

        try {
            return WeatherAlertMapper.toDto(weatherAlertRepository.save(alert));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public WeatherAlertDTO update(WeatherAlertDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("WeatherAlertDTO must not be null");
        if (dto.getId() == null)
            throw new IllegalArgumentException("id is required for update");

        WeatherAlert existing = weatherAlertRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("WeatherAlert not found"));

        if (dto.getTripId() != null && !dto.getTripId().equals(existing.getTrip().getId())) {
            throw new IllegalArgumentException("Trip cannot be change");
        }

        if (dto.getSnapshotId() != null && !dto.getSnapshotId().equals(existing.getSnapshot().getId())) {
            throw new IllegalArgumentException("SnapshotId cannot be change");
        }

        if (dto.getSeverity() != null)
            existing.setSeverity(dto.getSeverity());
        if (dto.getAlertType() != null)
            existing.setAlertType(dto.getAlertType());
        if (dto.getSuggestedAction() != null)
            existing.setSuggestedAction(trimToNull(dto.getSuggestedAction()));

        Boolean resolvedState = dto.getIsResolved();
        if (resolvedState != null) {
            if (resolvedState && !existing.isResolved()) {
                existing.setResolved(true);
                existing.setResolvedAt(dto.getResolvedAt() != null ? dto.getResolvedAt() : Instant.now());
            } else if (!resolvedState && existing.isResolved()) {
                existing.setResolved(false);
                existing.setResolvedAt(null);
            }
        }
        try {
            return WeatherAlertMapper.toDto(weatherAlertRepository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public WeatherAlertDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return weatherAlertRepository.findById(id).map(WeatherAlertMapper::toDto).orElse(null);
    }

    @Override
    public List<WeatherAlertDTO> findByTripId(Long tripId) {
        if (tripId == null)
            throw new IllegalArgumentException("tripId is required");
        return weatherAlertRepository.findByTripId(tripId)
                .stream()
                .map(WeatherAlertMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<WeatherAlertDTO> findUnresolvedByTripId(Long tripId) {
        if (tripId == null)
            throw new IllegalArgumentException("tripId is required");
        return weatherAlertRepository.findByTripIdAndIsResolvedFalse(tripId)
                .stream()
                .map(WeatherAlertMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    public List<WeatherAlertDTO> listAll() {
        return weatherAlertRepository.findAll()
                .stream()
                .map(WeatherAlertMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!weatherAlertRepository.existsById(id)) {
            throw new IllegalArgumentException("WeatherAlert not found");
        }
        weatherAlertRepository.deleteById(id);
    }

    @Override
    @Transactional
    public WeatherAlertDTO markResolved(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        WeatherAlert existing = weatherAlertRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("WeatherAlert not found"));
        if (!existing.isResolved()) {
            existing.setResolved(true);
            existing.setResolvedAt(Instant.now());
        }
        return WeatherAlertMapper.toDto(weatherAlertRepository.save(existing));
    }

    private String trimToNull(String value) {
        if (value == null)
            return null;
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

}