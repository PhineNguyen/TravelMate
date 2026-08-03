package com.travelmate.backend.dto.response;

import com.travelmate.backend.entity.enums.TripStatus;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TripMiniResponse {
    private Long id;
    private String destination;
    private LocalDate startDate;
    private TripStatus tripStatus;
}
