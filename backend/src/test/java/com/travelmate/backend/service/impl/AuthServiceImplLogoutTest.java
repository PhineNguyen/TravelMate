package com.travelmate.backend.service.impl;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.travelmate.backend.mapper.UserMapper;
import com.travelmate.backend.repository.OAuthAccountRepository;
import com.travelmate.backend.repository.PasswordResetTokenRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.security.JwtService;
import com.travelmate.backend.service.PasswordResetMailService;
import com.travelmate.backend.service.TokenRevocationService;

import java.time.Instant;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

@ExtendWith(MockitoExtension.class)
class AuthServiceImplLogoutTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordResetTokenRepository passwordResetTokenRepository;

    @Mock
    private OAuthAccountRepository oauthAccountRepository;

    @Mock
    private PasswordResetMailService passwordResetMailService;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private TokenRevocationService tokenRevocationService;

    @Mock
    private UserMapper userMapper;

    private final JwtService jwtService = new JwtService(
            "TravelMateJwtSecretKeyTravelMateJwtSecretKeyTravelMateJwtSecretKey",
            120);

    private AuthServiceImpl authService;

    @BeforeEach
    void setUp() {
        authService = new AuthServiceImpl(
                userRepository,
                passwordResetTokenRepository,
                oauthAccountRepository,
                passwordResetMailService,
                passwordEncoder,
                jwtService,
                tokenRevocationService,
                userMapper);
    }

    @Test
    void logoutRevokesCurrentAccessTokenWhenTokenIsValidAndActive() {
        String accessToken = jwtService.generateAccessToken(42L, "alex@example.com");
        when(tokenRevocationService.isRevoked(jwtService.extractJti(accessToken))).thenReturn(false);

        authService.logout(new com.travelmate.backend.dto.request.LogoutRequest(accessToken));

        verify(tokenRevocationService).revoke(
                eq(jwtService.extractJti(accessToken)),
                eq(jwtService.extractExpiration(accessToken)));
    }

    @Test
    void logoutThrowsWhenTokenIsMissing() {
        IllegalArgumentException exception = assertThrows(
                IllegalArgumentException.class,
                () -> authService.logout(null));

        assertEquals("Refresh token is required", exception.getMessage());
        verify(tokenRevocationService, org.mockito.Mockito.never()).revoke(any(), any());
    }

    @Test
    void logoutThrowsWhenTokenAlreadyRevoked() {
        String accessToken = jwtService.generateAccessToken(42L, "alex@example.com");
        when(tokenRevocationService.isRevoked(jwtService.extractJti(accessToken))).thenReturn(true);

        IllegalStateException exception = assertThrows(
                IllegalStateException.class,
                () -> authService.logout(new com.travelmate.backend.dto.request.LogoutRequest(accessToken)));

        assertEquals("Token is invalid or already revoked", exception.getMessage());
        verify(tokenRevocationService, org.mockito.Mockito.never()).revoke(any(), any());
    }
}