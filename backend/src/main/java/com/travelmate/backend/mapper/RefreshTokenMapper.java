package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.request.RefreshTokenRequest;
import com.travelmate.backend.dto.response.RefreshTokenResponse;
import com.travelmate.backend.entity.RefreshToken;

public class RefreshTokenMapper {
    public static RefreshToken toEntity(RefreshTokenRequest req) {
        if (req == null)
            return null;
        RefreshToken t = new RefreshToken();
        t.setTokenHash(req.getTokenHash());
        t.setExpiryDate(req.getExpiryDate());
        t.setRevoked(req.getRevoked() != null ? req.getRevoked() : false);
        return t;
    }

    public static RefreshTokenResponse toResponse(RefreshToken t) {
        if (t == null)
            return null;
        return RefreshTokenResponse.builder()
                .id(t.getId())
                .userId(t.getUser() != null ? t.getUser().getId() : null)
                .expiryDate(t.getExpiryDate())
                .revoked(t.isRevoked())
                .createdAt(t.getCreatedAt())
                .build();
    }
}
