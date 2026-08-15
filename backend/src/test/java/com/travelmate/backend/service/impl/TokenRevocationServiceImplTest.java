package com.travelmate.backend.service.impl;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.travelmate.backend.entity.AccessTokenRevocation;
import com.travelmate.backend.repository.AccessTokenRevocationRepository;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class TokenRevocationServiceImplTest {

    @Mock
    private AccessTokenRevocationRepository accessTokenRevocationRepository;

    @InjectMocks
    private TokenRevocationServiceImpl tokenRevocationService;

    @Test
    void revokePersistsJtiUntilTokenExpires() {
        Instant expiresAt = Instant.now().plus(15, ChronoUnit.MINUTES);

        when(accessTokenRevocationRepository.findByJti("token-jti")).thenReturn(Optional.empty());

        tokenRevocationService.revoke("token-jti", expiresAt);

        ArgumentCaptor<AccessTokenRevocation> captor = ArgumentCaptor.forClass(AccessTokenRevocation.class);
        verify(accessTokenRevocationRepository).save(captor.capture());
        AccessTokenRevocation saved = captor.getValue();

        assertEquals("token-jti", saved.getJti());
        assertEquals(expiresAt, saved.getExpiresAt());
    }

    @Test
    void isRevokedReturnsTrueWhenActiveRevocationExists() {
        AccessTokenRevocation revocation = AccessTokenRevocation.builder()
                .jti("token-jti")
                .expiresAt(Instant.now().plus(15, ChronoUnit.MINUTES))
                .build();

        when(accessTokenRevocationRepository.findByJti("token-jti")).thenReturn(Optional.of(revocation));

        assertTrue(tokenRevocationService.isRevoked("token-jti"));
    }

    @Test
    void isRevokedReturnsFalseWhenRevocationExpired() {
        AccessTokenRevocation revocation = AccessTokenRevocation.builder()
                .jti("token-jti")
                .expiresAt(Instant.now().minus(15, ChronoUnit.MINUTES))
                .build();

        when(accessTokenRevocationRepository.findByJti("token-jti")).thenReturn(Optional.of(revocation));

        assertFalse(tokenRevocationService.isRevoked("token-jti"));
    }
}