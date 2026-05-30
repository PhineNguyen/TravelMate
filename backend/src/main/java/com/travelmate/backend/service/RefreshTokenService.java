package com.travelmate.backend.service;

import com.travelmate.backend.dto.request.RefreshTokenRequest;
import com.travelmate.backend.dto.response.RefreshTokenResponse;
import java.util.List;

public interface RefreshTokenService {
    RefreshTokenResponse create(RefreshTokenRequest dto);

    RefreshTokenResponse update(RefreshTokenRequest dto);

    RefreshTokenResponse findById(Long id);

    List<RefreshTokenResponse> listAll();

    void delete(Long id);
}
