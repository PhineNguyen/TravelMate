package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.TemplateItemDTO;
import com.travelmate.backend.entity.TemplateItem;

public class TemplateItemMapper {
    public static TemplateItemDTO toDto(TemplateItem t) {
        if (t == null)
            return null;
        return TemplateItemDTO.builder()
                .id(t.getId())
                .templateId(t.getTemplate() != null ? t.getTemplate().getId() : null)
                .placeId(t.getPlace() != null ? t.getPlace().getId() : null)
                .dayNumber(t.getDayNumber())
                .orderIndex(t.getOrderIndex())
                .startTime(t.getStartTime())
                .duration(t.getDuration())
                .note(t.getNote())
                .isOptional(t.isOptional())
                .build();
    }
}
