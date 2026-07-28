package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.request.AuthRegisterRequest;
import com.travelmate.backend.dto.request.UserRequest;
import com.travelmate.backend.dto.response.UserResponse;
import com.travelmate.backend.entity.User;

import org.mapstruct.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;

@Mapper(componentModel = "spring", // creating a spring bean (@component)
        unmappedTargetPolicy = ReportingPolicy.IGNORE, // ignore warnings when execute
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE) // ignore null variables, do not
                                                                                    // overwrite

public abstract class UserMapper {
    @Autowired
    protected PasswordEncoder passwordEncoder;

    @Mapping(target = "password", expression = "java(passwordEncoder.encode(req.getPassword()))")
    @Mapping(target = "active", constant = "true")
    public abstract User toUser(AuthRegisterRequest req);

    @Mapping(target = "id", ignore = true)
    @Mapping(target = "password", ignore = true) // Password must be handled separately in the service
    public abstract User toUser(UserRequest request);

    public abstract UserResponse toResponse(User user);

    @Mapping(target = "password", ignore = true)
    public abstract void updateUserFromRequest(UserRequest request, @MappingTarget User user);

    @AfterMapping
    protected void handlePasswordUpdate(UserRequest request, @MappingTarget User user) {
        if (request.getPassword() != null && !request.getPassword().isBlank()) {
            user.setPassword(passwordEncoder.encode(request.getPassword()));
        }
    }
}