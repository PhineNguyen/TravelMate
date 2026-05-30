package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.WeatherSnapshotDTO;
import com.travelmate.backend.entity.WeatherSnapshot;

public class WeatherSnapshotMapper {
    public static WeatherSnapshotDTO toDto(WeatherSnapshot e) {
        if (e == null)
            return null;
        return WeatherSnapshotDTO.builder()
                .id(e.getId())
                .tripId(e.getTrip() != null ? e.getTrip().getId() : null)
                .date(e.getDate())
                .temperature(e.getTemperature())
                .humidity(e.getHumidity())
                .rainProbability(e.getRainProbability())
                .condition(e.getCondition())
                .windSpeed(e.getWindSpeed())
                .uvIndex(e.getUvIndex())
                .visibility(e.getVisibility())
                .alertLevel(e.getAlertLevel())
                .city(e.getCity())
                .isOutdoorSafe(e.isOutdoorSafe())
                .expiresAt(e.getExpiresAt())
                .createdAt(e.getCreatedAt())
                .updatedAt(e.getUpdatedAt())
                .providerName(e.getProviderName())
                .providerRecordedAt(e.getProviderRecordedAt())
                .providerId(e.getProviderId())
                .providerPayload(e.getProviderPayload())
                .build();
    }
}
