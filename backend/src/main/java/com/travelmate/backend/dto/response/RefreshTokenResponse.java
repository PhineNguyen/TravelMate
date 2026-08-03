package com.travelmate.backend.dto.response;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RefreshTokenResponse {
    private Long id;
    private Long userId;
    private LocalDateTime expiryDate;
    private Boolean revoked;
    private LocalDateTime createdAt;
}
