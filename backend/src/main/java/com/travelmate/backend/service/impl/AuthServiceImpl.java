package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.request.AuthLoginRequest;
import com.travelmate.backend.dto.request.AuthRefreshRequest;
import com.travelmate.backend.dto.request.AuthRegisterRequest;
import com.travelmate.backend.dto.response.AuthResponse;
import com.travelmate.backend.dto.response.UserResponse;
import com.travelmate.backend.mapper.UserMapper;
import com.travelmate.backend.entity.RefreshToken;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.repository.RefreshTokenRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.security.JwtService;
import com.travelmate.backend.service.AuthService;
import java.util.NoSuchElementException;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {
    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    @Override
    @Transactional
    public AuthResponse register(AuthRegisterRequest request) {
        validateRegisterRequest(request);
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }

        User user = new User();
        user.setFullName(request.getFullName());
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setAvatarUrl(request.getAvatarUrl());
        user.setActive(true);

        User savedUser = userRepository.save(user);
        return issueTokens(savedUser);
    }

    @Override
    @Transactional
    public AuthResponse login(AuthLoginRequest request) {
        if (request == null) {
            throw new IllegalArgumentException("Login request must not be null");
        }
        if (request.getEmail() == null || request.getEmail().isBlank()) {
            throw new IllegalArgumentException("Email is required");
        }
        if (request.getPassword() == null || request.getPassword().isBlank()) {
            throw new IllegalArgumentException("Password is required");
        }

        User user = userRepository.findByEmailAndActiveTrue(request.getEmail())
                .orElseThrow(() -> new NoSuchElementException("User not found or inactive"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("Invalid email or password");
        }

        return issueTokens(user);
    }

    @Override
    @Transactional
    public AuthResponse refresh(AuthRefreshRequest request) {
        if (request == null || request.getRefreshToken() == null || request.getRefreshToken().isBlank()) {
            throw new IllegalArgumentException("Refresh token is required");
        }

        String tokenHash = jwtService.hashToken(request.getRefreshToken());
        RefreshToken existing = refreshTokenRepository.findByTokenHash(tokenHash)
                .orElseThrow(() -> new IllegalArgumentException("Refresh token not found"));

        if (existing.isRevoked()) {
            throw new IllegalArgumentException("Refresh token was revoked");
        }
        if (existing.getExpiryDate().isBefore(java.time.LocalDateTime.now())) {
            throw new IllegalArgumentException("Refresh token expired");
        }

        User user = existing.getUser();
        existing.setRevoked(true);
        refreshTokenRepository.save(existing);

        return issueTokens(user);
    }

    @Override
    @Transactional
    public void logout(String refreshToken) {
        if (refreshToken == null || refreshToken.isBlank()) {
            throw new IllegalArgumentException("Refresh token is required");
        }

        String tokenHash = jwtService.hashToken(refreshToken);
        RefreshToken existing = refreshTokenRepository.findByTokenHash(tokenHash)
                .orElseThrow(() -> new IllegalArgumentException("Refresh token not found"));
        existing.setRevoked(true);
        refreshTokenRepository.save(existing);
    }

    private AuthResponse issueTokens(User user) {
        String accessToken = jwtService.generateAccessToken(user.getId(), user.getEmail());
        String refreshToken = jwtService.generateRawRefreshToken();

        RefreshToken refreshTokenEntity = RefreshToken.builder()
                .user(user)
                .tokenHash(jwtService.hashToken(refreshToken))
                .expiryDate(jwtService.refreshTokenExpiry())
                .revoked(false)
                .build();
        refreshTokenRepository.save(refreshTokenEntity);

        return AuthResponse.builder()
                .tokenType("Bearer")
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .expiresInSeconds(jwtService.getAccessTokenTtlSeconds())
                .user(UserMapper.toResponse(user))
                .build();
    }

    private void validateRegisterRequest(AuthRegisterRequest request) {
        if (request == null) {
            throw new IllegalArgumentException("Register request must not be null");
        }
        if (request.getFullName() == null || request.getFullName().isBlank()) {
            throw new IllegalArgumentException("Full name is required");
        }
        if (request.getEmail() == null || request.getEmail().isBlank()) {
            throw new IllegalArgumentException("Email is required");
        }
        if (request.getPassword() == null || request.getPassword().isBlank()) {
            throw new IllegalArgumentException("Password is required");
        }
    }

}