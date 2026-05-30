package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.request.UserRequest;
import com.travelmate.backend.dto.response.UserResponse;
import com.travelmate.backend.entity.User;

public class UserMapper {
    public static User toEntity(UserRequest req) {
        if (req == null)
            return null;
        User u = new User();
        u.setFullName(req.getFullName());
        u.setEmail(req.getEmail());
        u.setAvatarUrl(req.getAvatarUrl());
        if (req.getActive() != null)
            u.setActive(req.getActive());
        return u;
    }

    public static UserResponse toResponse(User u) {
        if (u == null)
            return null;
        return UserResponse.builder()
                .id(u.getId())
                .fullName(u.getFullName())
                .email(u.getEmail())
                .avatarUrl(u.getAvatarUrl())
                .active(u.isActive())
                .build();
    }
}
