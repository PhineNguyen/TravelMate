package com.travelmate.backend.service;

import com.travelmate.backend.dto.request.AuthLoginRequest;
import com.travelmate.backend.dto.request.AuthRefreshRequest;
import com.travelmate.backend.dto.request.AuthRegisterRequest;
import com.travelmate.backend.dto.response.AuthResponse;

public interface AuthService {
    AuthResponse register(AuthRegisterRequest request);

    AuthResponse login(AuthLoginRequest request);

    AuthResponse refresh(AuthRefreshRequest request);

    void logout(String refreshToken);
}