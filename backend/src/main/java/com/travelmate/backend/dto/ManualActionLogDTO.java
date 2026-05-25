package com.travelmate.backend.dto;

import lombok.*;
import java.time.LocalDateTime;
import com.travelmate.backend.entity.enums.ManualActionType;

@Data
@AllArgsConstructor
@Builder
public class ManualActionLogDTO {
    private Long id;
    private Long tripId;
    private Long userId;
    private Long targetItemId;
    private ManualActionType actionType;
    private LocalDateTime timestamp;
}
