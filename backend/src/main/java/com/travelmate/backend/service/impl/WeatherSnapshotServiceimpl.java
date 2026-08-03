package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.WeatherSnapshotDTO;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.WeatherSnapshot;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.repository.WeatherSnapshotRepository;
import com.travelmate.backend.service.WeatherSnapshotService;
import com.travelmate.backend.mapper.WeatherSnapshotMapper;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class WeatherSnapshotServiceimpl implements WeatherSnapshotService {

    private final WeatherSnapshotRepository weatherSnapshotRepository;
    private final TripRepository tripRepository;

    @Override
    @Transactional
    public WeatherSnapshotDTO create(WeatherSnapshotDTO dto) {
        if (dto == null) {
            throw new IllegalArgumentException("WeatherSnapshotDTO must not be null");
        }
        if (dto.getId() != null) {
            throw new IllegalArgumentException("id must be null when creating");
        }
        if (dto.getTripId() == null) {
            throw new IllegalArgumentException("tripId is required");
        }
        if (dto.getDate() == null) {
            throw new IllegalArgumentException("date is required");
        }

        Trip trip = tripRepository.findById(dto.getTripId())
                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));

        if (weatherSnapshotRepository.existsByTripIdAndDate(dto.getTripId(), dto.getDate())) {
            throw new IllegalArgumentException("WeatherSnapshot already exists for this trip and date");
        }

        WeatherSnapshot snapshot = WeatherSnapshot.builder()
                .trip(trip)
                .date(dto.getDate())
                .temperature(dto.getTemperature())
                .humidity(dto.getHumidity())
                .rainProbability(dto.getRainProbability())
                .condition(trimToNull(dto.getCondition()))
                .windSpeed(dto.getWindSpeed())
                .uvIndex(dto.getUvIndex())
                .visibility(dto.getVisibility())
                .alertLevel(trimToNull(dto.getAlertLevel()))
                .city(trimToNull(dto.getCity()))
                .isOutdoorSafe(dto.getIsOutdoorSafe())
                .expiresAt(dto.getExpiresAt())
                .providerName(trimToNull(dto.getProviderName()))
                .providerRecordedAt(dto.getProviderRecordedAt())
                .providerId(trimToNull(dto.getProviderId()))
                .providerPayload(dto.getProviderPayload())
                .build();

        try {
            return WeatherSnapshotMapper.toDto(weatherSnapshotRepository.save(snapshot));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public WeatherSnapshotDTO update(WeatherSnapshotDTO dto) {
        if (dto == null) {
            throw new IllegalArgumentException("WeatherSnapshotDTO must not be null");
        }
        if (dto.getId() == null) {
            throw new IllegalArgumentException("id is required for update");
        }

        WeatherSnapshot existing = weatherSnapshotRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("WeatherSnapshot not found"));

        Long targetTripId = dto.getTripId() != null ? dto.getTripId() : existing.getTrip().getId();
        LocalDate targetDate = dto.getDate() != null ? dto.getDate() : existing.getDate();

        if (dto.getTripId() != null && !dto.getTripId().equals(existing.getTrip().getId())) {
            Trip trip = tripRepository.findById(dto.getTripId())
                    .orElseThrow(() -> new IllegalArgumentException("Trip not found"));
            existing.setTrip(trip);
        }

        if (dto.getDate() != null && !dto.getDate().equals(existing.getDate())) {
            existing.setDate(dto.getDate());
        }

        if ((dto.getTripId() != null || dto.getDate() != null)
                && weatherSnapshotRepository.existsByTripIdAndDate(targetTripId, targetDate)
                && !(existing.getTrip().getId().equals(targetTripId) && existing.getDate().equals(targetDate))) {
            throw new IllegalArgumentException("WeatherSnapshot already exists for this trip and date");
        }

        if (dto.getTemperature() != null)
            existing.setTemperature(dto.getTemperature());
        if (dto.getHumidity() != null)
            existing.setHumidity(dto.getHumidity());
        if (dto.getRainProbability() != null)
            existing.setRainProbability(dto.getRainProbability());
        if (dto.getCondition() != null)
            existing.setCondition(trimToNull(dto.getCondition()));
        if (dto.getWindSpeed() != null)
            existing.setWindSpeed(dto.getWindSpeed());
        if (dto.getUvIndex() != null)
            existing.setUvIndex(dto.getUvIndex());
        if (dto.getVisibility() != null)
            existing.setVisibility(dto.getVisibility());
        if (dto.getAlertLevel() != null)
            existing.setAlertLevel(trimToNull(dto.getAlertLevel()));
        if (dto.getCity() != null)
            existing.setCity(trimToNull(dto.getCity()));
        if (dto.getExpiresAt() != null)
            existing.setExpiresAt(dto.getExpiresAt());
        if (dto.getProviderName() != null)
            existing.setProviderName(trimToNull(dto.getProviderName()));
        if (dto.getProviderRecordedAt() != null)
            existing.setProviderRecordedAt(dto.getProviderRecordedAt());
        if (dto.getProviderId() != null)
            existing.setProviderId(trimToNull(dto.getProviderId()));
        if (dto.getProviderPayload() != null)
            existing.setProviderPayload(dto.getProviderPayload());
        if (dto.getIsOutdoorSafe() != null)
            existing.setOutdoorSafe(dto.getIsOutdoorSafe());

        try {
            return WeatherSnapshotMapper.toDto(weatherSnapshotRepository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public WeatherSnapshotDTO findById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("id is required");
        }
        return weatherSnapshotRepository.findById(id)
                .map(WeatherSnapshotMapper::toDto)
                .orElse(null);
    }

    @Override
    public List<WeatherSnapshotDTO> listAll() {
        return weatherSnapshotRepository.findAll()
                .stream()
                .map(WeatherSnapshotMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("id is required");
        }
        if (!weatherSnapshotRepository.existsById(id)) {
            throw new IllegalArgumentException("WeatherSnapshot not found");
        }
        weatherSnapshotRepository.deleteById(id);
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

}