package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.AnalyticsSnapshotDTO;
import com.travelmate.backend.entity.AnalyticsSnapshot;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.repository.AnalyticsSnapshotRepository;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.service.AnalyticsSnapshotService;
import com.travelmate.backend.mapper.AnalyticsSnapshotMapper;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class AnalyticsSnapshotServiceImpl implements AnalyticsSnapshotService {

    private final AnalyticsSnapshotRepository analyticsSnapshotRepository;
    private final TripRepository tripRepository;

    @Override
    @Transactional
    public AnalyticsSnapshotDTO create(AnalyticsSnapshotDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("AnalyticsSnapshotDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getTripId() == null)
            throw new IllegalArgumentException("tripId is required");

        Trip trip = tripRepository.findById(dto.getTripId())
                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));

        AnalyticsSnapshot a = AnalyticsSnapshot.builder()
                .trip(trip)
                .totalTrips(dto.getTotalTrips() != null ? dto.getTotalTrips() : 0)
                .avgBudget(dto.getAvgBudget())
                .totalSpent(dto.getTotalSpent())
                .favoriteCategory(trimToNull(dto.getFavoriteCategory()))
                .mostVisitedDestination(trimToNull(dto.getMostVisitedDestination()))
                .travelPersonality(trimToNull(dto.getTravelPersonality()))
                .build();

        try {
            return AnalyticsSnapshotMapper.toDto(analyticsSnapshotRepository.save(a));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public AnalyticsSnapshotDTO update(AnalyticsSnapshotDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("AnalyticsSnapshotDTO must not be null");
        if (dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");

        AnalyticsSnapshot existing = analyticsSnapshotRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("Snapshot not found"));

        if (dto.getTotalTrips() != null)
            existing.setTotalTrips(dto.getTotalTrips());
        if (dto.getAvgBudget() != null)
            existing.setAvgBudget(dto.getAvgBudget());
        if (dto.getTotalSpent() != null)
            existing.setTotalSpent(dto.getTotalSpent());
        if (dto.getFavoriteCategory() != null)
            existing.setFavoriteCategory(trimToNull(dto.getFavoriteCategory()));
        if (dto.getMostVisitedDestination() != null)
            existing.setMostVisitedDestination(trimToNull(dto.getMostVisitedDestination()));
        if (dto.getTravelPersonality() != null)
            existing.setTravelPersonality(trimToNull(dto.getTravelPersonality()));

        try {
            return AnalyticsSnapshotMapper.toDto(analyticsSnapshotRepository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public AnalyticsSnapshotDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return analyticsSnapshotRepository.findById(id).map(AnalyticsSnapshotMapper::toDto).orElse(null);
    }

    @Override
    public List<AnalyticsSnapshotDTO> listAll() {
        return analyticsSnapshotRepository.findAll().stream().map(AnalyticsSnapshotMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!analyticsSnapshotRepository.existsById(id))
            throw new IllegalArgumentException("Snapshot not found");
        analyticsSnapshotRepository.deleteById(id);
    }

    private String trimToNull(String v) {
        if (v == null)
            return null;
        String t = v.trim();
        return t.isEmpty() ? null : t;
    }
}
