package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.ManualActionLogDTO;
import com.travelmate.backend.entity.ManualActionLog;

public class ManualActionLogMapper {
    public static ManualActionLogDTO toDto(ManualActionLog m) {
        if (m == null)
            return null;
        return ManualActionLogDTO.builder()
                .id(m.getId())
                .tripId(m.getTrip() != null ? m.getTrip().getId() : null)
                .userId(m.getUser() != null ? m.getUser().getId() : null)
                .targetItemId(m.getTargetItem() != null ? m.getTargetItem().getId() : null)
                .actionType(m.getActionType())
                .timestamp(m.getTimestamp())
                .build();
    }
}
