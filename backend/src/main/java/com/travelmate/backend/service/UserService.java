package com.travelmate.backend.service;

import com.travelmate.backend.dto.request.UserRequest;
import com.travelmate.backend.dto.response.UserResponse;
import com.travelmate.backend.dto.request.ProfileUpdateRequest;

import java.util.List;

public interface UserService {
    UserResponse create(UserRequest dto);

    UserResponse update(Long id, ProfileUpdateRequest request);

    UserResponse completeOnboarding(Long id);

    UserResponse findById(Long id);

    List<UserResponse> listAll();

    void delete(Long id);
}
