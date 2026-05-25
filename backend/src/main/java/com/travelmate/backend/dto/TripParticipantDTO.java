package com.travelmate.backend.dto;

import com.travelmate.backend.entity.enums.ParticipantRole;
import java.time.LocalDateTime;
import lombok.*;

@Data
@AllArgsConstructor
@Builder
public class TripParticipantDTO {
    private Long id;
    private Long tripId;
    private Long userId;
    private ParticipantRole role;
    private LocalDateTime joinedAt;
    private boolean isActive;

}
