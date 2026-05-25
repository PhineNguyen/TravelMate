package com.travelmate.backend.dto;

import lombok.*;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RefreshTokenDTO {
    private Long id;
    private Long userId;
    private LocalDateTime expiryDate;
    private boolean revoked;
    private LocalDateTime createdAt;
}
