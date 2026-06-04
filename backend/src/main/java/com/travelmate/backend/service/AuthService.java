package com.travelmate.backend.service;

import com.travelmate.backend.dto.request.AuthLoginRequest;
import com.travelmate.backend.dto.request.OAuthLoginRequest;
import com.travelmate.backend.dto.request.AuthRefreshRequest;
import com.travelmate.backend.dto.request.AuthRegisterRequest;
import com.travelmate.backend.dto.request.PasswordResetConfirmRequest;
import com.travelmate.backend.dto.request.PasswordResetRequest;
import com.travelmate.backend.dto.response.AuthResponse;
import com.travelmate.backend.dto.response.PasswordResetResponse;

public interface AuthService {
    AuthResponse register(AuthRegisterRequest request);

    AuthResponse login(AuthLoginRequest request);

    AuthResponse oauthLogin(OAuthLoginRequest request);

    AuthResponse refresh(AuthRefreshRequest request);

    void logout(String refreshToken);

    PasswordResetResponse requestPasswordReset(PasswordResetRequest request);

    void confirmPasswordReset(PasswordResetConfirmRequest request);
}