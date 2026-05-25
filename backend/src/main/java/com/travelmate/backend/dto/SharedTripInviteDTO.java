package com.travelmate.backend.dto;

import com.travelmate.backend.entity.enums.InviteStatus;
import java.time.LocalDateTime;
import lombok.*;

@Data
@AllArgsConstructor
@Builder
public class SharedTripInviteDTO {
    private Long id;
    private Long tripId;
    private Long senderId;
    private String receiverEmail;
    private String inviteCode;
    private InviteStatus status; // sửa inviteStatus → status
    private LocalDateTime expiresAt;
    private LocalDateTime createdAt;
}