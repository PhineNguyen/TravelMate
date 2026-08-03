package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.TripTemplateDTO;
import com.travelmate.backend.entity.TripTemplate;

import java.math.RoundingMode;

public class TripTemplateMapper {
    public static void applyDtoToEntity(TripTemplateDTO dto, TripTemplate e) {
        e.setTitle(trimToNull(dto.getTitle()));
        e.setDestination(trimToNull(dto.getDestination()));
        e.setCategory(trimToNull(dto.getCategory()));
        e.setDuration(dto.getDuration());
        e.setThumbnailUrl(trimToNull(dto.getThumbnailUrl()));
        e.setDescription(trimToNull(dto.getDescription()));
        e.setPopularityScore(dto.getPopularityScore());
        if (dto.getEstimatedBudget() != null) {
            e.setEstimatedBudget(dto.getEstimatedBudget().setScale(2, RoundingMode.HALF_UP));
        } else {
            e.setEstimatedBudget(null);
        }
    }

    public static TripTemplateDTO toDto(TripTemplate e) {
        if (e == null)
            return null;
        return TripTemplateDTO.builder()
                .id(e.getId())
                .tripId(null)
                .title(e.getTitle())
                .destination(e.getDestination())
                .category(e.getCategory())
                .duration(e.getDuration())
                .estimatedBudget(e.getEstimatedBudget())
                .thumbnailUrl(e.getThumbnailUrl())
                .description(e.getDescription())
                .popularityScore(e.getPopularityScore())
                .createdAt(e.getCreatedAt())
                .build();
    }

    public static String trimToNull(String v) {
        if (v == null)
            return null;
        String t = v.trim();
        return t.isEmpty() ? null : t;
    }
}
