package com.travelmate.backend.dto;

import com.travelmate.backend.entity.enums.AlertSeverity;
import com.travelmate.backend.entity.enums.AlertType;
import java.time.Instant;
import lombok.*;

@Data
@AllArgsConstructor
@Builder
public class WeatherAlertDTO {
    private Long id;
    private Long tripId;
    private Long snapshotId;
    private AlertSeverity severity;
    private AlertType alertType;
    private String suggestedAction;
    private boolean isResolved;
    private Instant createdAt;
    private Instant resolvedAt;
}
