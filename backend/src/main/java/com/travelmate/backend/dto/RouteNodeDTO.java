package com.travelmate.backend.dto;

import lombok.*;
import java.time.LocalTime;

@Data
@AllArgsConstructor
@Builder
public class RouteNodeDTO {
    private Long id;
    private Long routePlanId;
    private Long placeId;
    private Integer sequenceOrder;
    private LocalTime arrivalTime;
    private LocalTime departureTime;
    private Integer travelMinutes;
}
