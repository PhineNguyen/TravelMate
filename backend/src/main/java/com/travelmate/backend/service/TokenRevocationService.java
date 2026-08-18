package com.travelmate.backend.service;

import java.time.Instant;

public interface TokenRevocationService {
    void revoke(String jti, Instant expiresAt);

    boolean isRevoked(String jti);

    void revokeAllForUser(Long userId);

    void cleanupExpired();
}