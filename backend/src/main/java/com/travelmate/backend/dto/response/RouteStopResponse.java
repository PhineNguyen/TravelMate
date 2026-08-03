package com.travelmate.backend.dto.response;

import java.time.LocalTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RouteStopResponse {
    private Integer sequenceOrder;
    private String placeName;
    private LocalTime arrivalTime;
    private LocalTime departureTime;
}
