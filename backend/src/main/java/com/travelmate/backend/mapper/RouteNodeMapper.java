package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.RouteNodeDTO;
import com.travelmate.backend.entity.RouteNode;

public class RouteNodeMapper {
    public static RouteNodeDTO toDto(RouteNode n) {
        if (n == null)
            return null;
        return RouteNodeDTO.builder()
                .id(n.getId())
                .routePlanId(n.getRoutePlan() != null ? n.getRoutePlan().getId() : null)
                .placeId(n.getPlace() != null ? n.getPlace().getId() : null)
                .sequenceOrder(n.getSequenceOrder())
                .arrivalTime(n.getArrivalTime())
                .departureTime(n.getDepartureTime())
                .travelMinutes(n.getTravelMinutes())
                .build();
    }
}
