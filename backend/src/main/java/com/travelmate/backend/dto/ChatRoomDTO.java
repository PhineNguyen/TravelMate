package com.travelmate.backend.dto;

import lombok.*;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ChatRoomDTO {
    private Long id;
    private Long tripId;
    private LocalDateTime createdAt;
}
