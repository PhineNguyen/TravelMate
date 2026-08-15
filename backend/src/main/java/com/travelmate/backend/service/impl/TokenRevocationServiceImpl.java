package com.travelmate.backend.service.impl;

import java.time.Instant;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.travelmate.backend.entity.AccessTokenRevocation;
import com.travelmate.backend.repository.AccessTokenRevocationRepository;
import com.travelmate.backend.service.TokenRevocationService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class TokenRevocationServiceImpl implements TokenRevocationService {
    private final AccessTokenRevocationRepository accessTokenRevocationRepository;

    @Override
    @Transactional
    public void revoke(String jti, Instant expiresAt) {
        if (jti == null || jti.isBlank() || expiresAt == null) {
            return;
        }

        AccessTokenRevocation revocation = accessTokenRevocationRepository.findByJti(jti)
                .orElseGet(() -> AccessTokenRevocation.builder()
                        .jti(jti)
                        .build());
        revocation.setExpiresAt(expiresAt);
        accessTokenRevocationRepository.save(revocation);
    }

    @Override
    @Transactional(readOnly = true)
    public boolean isRevoked(String jti) {
        if (jti == null || jti.isBlank()) {
            return false;
        }

        return accessTokenRevocationRepository.findByJti(jti)
                .filter(revocation -> revocation.getExpiresAt() != null
                        && revocation.getExpiresAt().isAfter(Instant.now()))
                .isPresent();
    }

    @Override
    @Transactional
    public void cleanupExpired() {
        accessTokenRevocationRepository.deleteByExpiresAtBefore(Instant.now());
    }
}