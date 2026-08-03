package com.travelmate.backend.dto.request;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RefreshTokenRequest {
    private Long id;
    private Long userId;
    private String tokenHash;
    private LocalDateTime expiryDate;
    private Boolean revoked;
}
