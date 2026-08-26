package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.request.AuthLoginRequest;
import com.travelmate.backend.dto.request.AuthRegisterRequest;
import com.travelmate.backend.dto.request.LogoutRequest;
import com.travelmate.backend.dto.request.OAuthLoginRequest;
import com.travelmate.backend.dto.request.PasswordResetConfirmRequest;
import com.travelmate.backend.dto.request.PasswordResetRequest;
import com.travelmate.backend.dto.response.AuthResponse;
import com.travelmate.backend.dto.response.PasswordResetResponse;
import com.travelmate.backend.entity.OAuthAccount;
import com.travelmate.backend.entity.PasswordResetToken;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.entity.enums.OAuthProvider;
import com.travelmate.backend.mapper.UserMapper;
import com.travelmate.backend.repository.OAuthAccountRepository;
import com.travelmate.backend.repository.PasswordResetTokenRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.security.JwtService;
import com.travelmate.backend.service.AuthService;
import com.travelmate.backend.service.PasswordResetMailService;
import com.travelmate.backend.service.TokenRevocationService;

import java.time.LocalDateTime;
import java.time.Instant;
import java.util.NoSuchElementException;
import java.util.UUID;

import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final UserRepository userRepository;
    private final PasswordResetTokenRepository passwordResetTokenRepository;
    private final OAuthAccountRepository oauthAccountRepository;
    private final PasswordResetMailService passwordResetMailService;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final TokenRevocationService tokenRevocationService;
    private final UserMapper userMapper; // 1. Khai báo private final để Lombok inject bean

    private String normalizeEmail(String email) {
        return email == null ? null : email.trim().toLowerCase();
    }

    @Override
    @Transactional
    public AuthResponse register(AuthRegisterRequest request) {
        validateRegisterRequest(request);
        validatePasswordPolicy(request.getPassword());
        String normalizeEmail = normalizeEmail(request.getEmail());
        if (userRepository.existsByEmail(normalizeEmail)) {
            throw new IllegalArgumentException("Email already exists");
        }

        User user = new User();
        user.setFullName(request.getFullName());
        user.setEmail(normalizeEmail);
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setOnboardingCompleted(false);
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
        String normalizedEmail = normalizeEmail(request.getEmail());
        User user = userRepository.findByEmailAndActiveTrue(normalizedEmail)
                .orElseThrow(() -> new NoSuchElementException("User not found or inactive"));

        if (user.isLocked()) {
            throw new IllegalArgumentException("Account is locked");
        }

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new IllegalArgumentException("Invalid email or password");
        }

        return issueTokens(user);
    }

    @Override
    @Transactional
    public AuthResponse oauthLogin(OAuthLoginRequest request) {
        if (request == null) {
            throw new IllegalArgumentException("OAuth request must not be null");
        }
        if (request.getProvider() == null) {
            throw new IllegalArgumentException("OAuth provider is required");
        }
        if (request.getProviderUserId() == null || request.getProviderUserId().isBlank()) {
            throw new IllegalArgumentException("OAuth providerUserId is required");
        }
        if (request.getEmail() == null || request.getEmail().isBlank()) {
            throw new IllegalArgumentException("OAuth email is required");
        }

        OAuthProvider provider = request.getProvider();
        OAuthAccount existingAccount = oauthAccountRepository
                .findByProviderAndProviderUserId(provider, request.getProviderUserId())
                .orElse(null);

        User user;
        if (existingAccount != null) {
            user = existingAccount.getUser();
        } else {
            String normalizedEmail = normalizeEmail(request.getEmail());
            user = userRepository.findByEmail(normalizedEmail)
                    .orElseGet(() -> {
                        User newUser = new User();
                        newUser.setFullName(request.getFullName() != null && !request.getFullName().isBlank()
                                ? request.getFullName()
                                : request.getEmail().split("@")[0]);
                        newUser.setEmail(normalizedEmail);
                        newUser.setPassword(passwordEncoder.encode(UUID.randomUUID().toString()));
                        newUser.setAvatarUrl(request.getAvatarUrl());
                        newUser.setActive(true);
                        return userRepository.save(newUser);
                    });

            if (!user.isActive()) {
                throw new IllegalArgumentException("User account is inactive");
            }

            oauthAccountRepository.save(OAuthAccount.builder()
                    .user(user)
                    .provider(provider)
                    .providerUserId(request.getProviderUserId())
                    .email(normalizedEmail)
                    .displayName(request.getFullName())
                    .avatarUrl(request.getAvatarUrl())
                    .build());
        }

        if (!user.isActive()) {
            throw new IllegalArgumentException("User account is inactive");
        }

        if (user.isLocked()) {
            throw new IllegalArgumentException("Account is locked");
        }

        return issueTokens(user);
    }

    @Override
    @Transactional
    public void logout(LogoutRequest request) {
        if (request == null || request.getRefreshToken() == null || request.getRefreshToken().isBlank()) {
            throw new IllegalArgumentException("Refresh token is required");
        }

        String rawToken = request.getRefreshToken().trim();
        if (!jwtService.isAccessTokenValid(rawToken)) {
            throw new IllegalStateException("Token is invalid or already revoked");
        }

        String jti = jwtService.extractJti(rawToken);
        if (tokenRevocationService.isRevoked(jti)) {
            throw new IllegalStateException("Token is invalid or already revoked");
        }

        Instant expiresAt = jwtService.extractExpiration(rawToken);
        tokenRevocationService.revoke(jti, expiresAt);
    }

    @Override
    @Transactional
    public PasswordResetResponse requestPasswordReset(PasswordResetRequest request) {
        if (request == null || request.getEmail() == null || request.getEmail().isBlank()) {
            throw new IllegalArgumentException("Email is required");
        }

        String normalizedEmail = normalizeEmail(request.getEmail());
        User user = userRepository.findByEmailAndActiveTrue(normalizedEmail)
                .orElseThrow(() -> new NoSuchElementException("Unknown email"));

        LocalDateTime oneHourAgo = LocalDateTime.now().minusHours(1);
        Long recentRequests = passwordResetTokenRepository.countByUserAndCreatedAtAfter(user, oneHourAgo);

        if (recentRequests >= 3) {
            throw new IllegalArgumentException("To many recent requests please wait 1 hour to continute");
        }
        String rawToken = UUID.randomUUID().toString().replace("-", "");
        PasswordResetToken token = PasswordResetToken.builder()
                .user(user)
                .tokenHash(jwtService.hashToken(rawToken))
                .expiresAt(LocalDateTime.now().plusMinutes(30))
                .used(false)
                .build();
        passwordResetTokenRepository.save(token);

        passwordResetMailService.sendResetMail(user, rawToken, token.getExpiresAt());

        return PasswordResetResponse.builder()
                .message("Password reset request created")
                .resetToken(rawToken)
                .expiresAt(token.getExpiresAt())
                .build();
    }

    @Override
    @Transactional
    public void confirmPasswordReset(PasswordResetConfirmRequest request) {
        if (request == null) {
            throw new IllegalArgumentException("Reset request must not be null");
        }
        if (request.getResetToken() == null || request.getResetToken().isBlank()) {
            throw new IllegalArgumentException("Reset token is required");
        }
        if (request.getNewPassword() == null || request.getNewPassword().isBlank()) {
            throw new IllegalArgumentException("New password is required");
        }

        validatePasswordPolicy(request.getNewPassword());

        PasswordResetToken resetToken = passwordResetTokenRepository
                .findByTokenHash(jwtService.hashToken(request.getResetToken()))
                .orElseThrow(() -> new IllegalArgumentException("Expired / invalid token"));

        if (resetToken.isUsed()) {
            throw new IllegalArgumentException("Expired / invalid token");
        }
        if (resetToken.getExpiresAt().isBefore(LocalDateTime.now())) {
            throw new IllegalArgumentException("Expired / invalid token");
        }

        User user = resetToken.getUser();
        if (passwordEncoder.matches(request.getNewPassword(), user.getPassword())) {
            throw new IllegalArgumentException("New password same as current");
        }

        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        userRepository.save(user);

        resetToken.setUsed(true);
        resetToken.setUsedAt(LocalDateTime.now());
        passwordResetTokenRepository.save(resetToken);
        tokenRevocationService.revokeAllForUser(user.getId());

    }

    private AuthResponse issueTokens(User user) {
        String accessToken = jwtService.generateAccessToken(user.getId(), user.getEmail());

        return AuthResponse.builder()
                .tokenType("Bearer")
                .accessToken(accessToken)
                .expiresInSeconds(jwtService.getAccessTokenTtlSeconds())
                .user(userMapper.toResponse(user))
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

    private void validatePasswordPolicy(String password) {
        if (password == null || password.length() < 8) {
            throw new IllegalArgumentException("Invalid password format");
        }
        if (!password.matches(".*[A-Z].*")) {
            throw new IllegalArgumentException("Invalid password format");
        }
        if (!password.matches(".*\\d.*")) {
            throw new IllegalArgumentException("Invalid password format");
        }
    }

    private String extractBearerToken(String authorizationHeader) {
        if (authorizationHeader == null || authorizationHeader.isBlank()) {
            return null;
        }
        if (!authorizationHeader.startsWith("Bearer ")) {
            return null;
        }
        return authorizationHeader.substring(7);
    }
}