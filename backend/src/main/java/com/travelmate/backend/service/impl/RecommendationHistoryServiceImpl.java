package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.RecommendationHistoryDTO;
import com.travelmate.backend.entity.Place;
import com.travelmate.backend.entity.RecommendationHistory;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.repository.PlaceRepository;
import com.travelmate.backend.repository.RecommendationHistoryRepository;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.service.RecommendationHistoryService;
import com.travelmate.backend.mapper.RecommendationHistoryMapper;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RecommendationHistoryServiceImpl implements RecommendationHistoryService {

    private final RecommendationHistoryRepository repository;
    private final UserRepository userRepository;
    private final TripRepository tripRepository;
    private final PlaceRepository placeRepository;

    @Override
    @Transactional
    public RecommendationHistoryDTO create(RecommendationHistoryDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("RecommendationHistoryDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getUserId() == null)
            throw new IllegalArgumentException("userId is required");
        if (dto.getTripId() == null)
            throw new IllegalArgumentException("tripId is required");
        if (dto.getScore() == null)
            throw new IllegalArgumentException("score is required");
        if (dto.getSourceEngine() == null)
            throw new IllegalArgumentException("sourceEngine is required");

        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));
        Trip trip = tripRepository.findById(dto.getTripId())
                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));
        Place place = null;
        if (dto.getPlaceId() != null)
            place = placeRepository.findById(dto.getPlaceId())
                    .orElseThrow(() -> new IllegalArgumentException("Place not found"));

        RecommendationHistory r = RecommendationHistory.builder()
                .user(user)
                .trip(trip)
                .place(place)
                .score(dto.getScore())
                .sourceEngine(dto.getSourceEngine())
                .queryContext(dto.getQueryContext())
                .recommendationReason(dto.getRecommendationReason())
                .build();

        try {
            return RecommendationHistoryMapper.toDto(repository.save(r));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public RecommendationHistoryDTO update(RecommendationHistoryDTO dto) {
        throw new UnsupportedOperationException("RecommendationHistory is append-only");
    }

    @Override
    public RecommendationHistoryDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return repository.findById(id).map(RecommendationHistoryMapper::toDto).orElse(null);
    }

    @Override
    public List<RecommendationHistoryDTO> listAll() {
        return repository.findAll().stream().map(RecommendationHistoryMapper::toDto).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!repository.existsById(id))
            throw new IllegalArgumentException("RecommendationHistory not found");
        repository.deleteById(id);
    }

}
