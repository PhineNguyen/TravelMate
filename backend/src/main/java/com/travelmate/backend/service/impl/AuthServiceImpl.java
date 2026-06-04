package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.request.AuthLoginRequest;
import com.travelmate.backend.dto.request.AuthRefreshRequest;
import com.travelmate.backend.dto.request.AuthRegisterRequest;
import com.travelmate.backend.dto.request.OAuthLoginRequest;
import com.travelmate.backend.dto.request.PasswordResetConfirmRequest;
import com.travelmate.backend.dto.request.PasswordResetRequest;
import com.travelmate.backend.dto.response.AuthResponse;
import com.travelmate.backend.dto.response.PasswordResetResponse;
import com.travelmate.backend.dto.response.UserResponse;
import com.travelmate.backend.entity.OAuthAccount;
import com.travelmate.backend.entity.PasswordResetToken;
import com.travelmate.backend.mapper.UserMapper;
import com.travelmate.backend.entity.RefreshToken;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.entity.enums.OAuthProvider;
import com.travelmate.backend.repository.OAuthAccountRepository;
import com.travelmate.backend.repository.PasswordResetTokenRepository;
import com.travelmate.backend.repository.RefreshTokenRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.security.JwtService;
import com.travelmate.backend.service.AuthService;
import com.travelmate.backend.service.PasswordResetMailService;
import java.util.NoSuchElementException;
import java.util.List;
import java.util.UUID;
import java.time.LocalDateTime;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {
    private final UserRepository userRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordResetTokenRepository passwordResetTokenRepository;
    private final OAuthAccountRepository oauthAccountRepository;
    private final PasswordResetMailService passwordResetMailService;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;

    @Override
    @Transactional
    public AuthResponse register(AuthRegisterRequest request) {
        validateRegisterRequest(request);
        validatePasswordPolicy(request.getPassword());
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
            user = userRepository.findByEmail(request.getEmail())
                    .orElseGet(() -> {
                        User newUser = new User();
                        newUser.setFullName(request.getFullName() != null && !request.getFullName().isBlank()
                                ? request.getFullName()
                                : request.getEmail().split("@")[0]);
                        newUser.setEmail(request.getEmail());
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
                    .email(request.getEmail())
                    .displayName(request.getFullName())
                    .avatarUrl(request.getAvatarUrl())
                    .build());
        }

        if (!user.isActive()) {
            throw new IllegalArgumentException("User account is inactive");
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

    @Override
    @Transactional
    public PasswordResetResponse requestPasswordReset(PasswordResetRequest request) {
        if (request == null || request.getEmail() == null || request.getEmail().isBlank()) {
            throw new IllegalArgumentException("Email is required");
        }

        User user = userRepository.findByEmailAndActiveTrue(request.getEmail())
                .orElseThrow(() -> new NoSuchElementException("Unknown email"));

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

        List<RefreshToken> activeTokens = refreshTokenRepository.findByUserIdAndRevokedFalse(user.getId());
        activeTokens.forEach(rt -> rt.setRevoked(true));
        refreshTokenRepository.saveAll(activeTokens);
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

}