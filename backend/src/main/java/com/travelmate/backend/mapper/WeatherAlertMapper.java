package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.WeatherAlertDTO;
import com.travelmate.backend.entity.WeatherAlert;

public class WeatherAlertMapper {
    public static WeatherAlertDTO toDto(WeatherAlert e) {
        if (e == null)
            return null;
        return WeatherAlertDTO.builder()
                .id(e.getId())
                .tripId(e.getTrip() != null ? e.getTrip().getId() : null)
                .snapshotId(e.getSnapshot() != null ? e.getSnapshot().getId() : null)
                .severity(e.getSeverity())
                .alertType(e.getAlertType())
                .suggestedAction(e.getSuggestedAction())
                .isResolved(e.isResolved())
                .createdAt(e.getCreatedAt())
                .resolvedAt(e.getResolvedAt())
                .build();
    }
}
