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
    private String tokenHash;
    private LocalDateTime expiryDate;
    private Boolean revoked;
    private LocalDateTime createdAt;
}
