package com.travelmate.backend.service;

import com.travelmate.backend.dto.request.UserRequest;
import com.travelmate.backend.dto.response.UserResponse;
import java.util.List;

public interface UserService {
    UserResponse create(UserRequest dto);

    UserResponse update(UserRequest dto);

    UserResponse findById(Long id);

    List<UserResponse> listAll();

    void delete(Long id);
}
