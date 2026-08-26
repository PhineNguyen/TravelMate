package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.request.AuthRegisterRequest;
import com.travelmate.backend.dto.request.UserRequest;
import com.travelmate.backend.dto.response.UserResponse;
import com.travelmate.backend.entity.User;

import org.mapstruct.*;

@Mapper(componentModel = "spring", // creating a spring bean (@component)
        unmappedTargetPolicy = ReportingPolicy.IGNORE, // ignore warnings when execute
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE) // ignore null variables, do not
                                                                                    // overwrite

public abstract class UserMapper {
    @BeanMapping(ignoreByDefault = true)
    @Mapping(target = "fullName", source = "fullName")
    @Mapping(target = "email", source = "email")
    @Mapping(target = "avatarUrl", source = "avatarUrl")
    @Mapping(target = "locked", constant = "false")
    @Mapping(target = "onboardingCompleted", constant = "false")
    @Mapping(target = "active", constant = "true")
    @Mapping(target = "password", ignore = true)
    public abstract User toUser(AuthRegisterRequest req);

    @BeanMapping(ignoreByDefault = true)
    @Mapping(target = "id", ignore = true)
    @Mapping(target = "fullName", source = "fullName")
    @Mapping(target = "email", source = "email")
    @Mapping(target = "avatarUrl", source = "avatarUrl")
    @Mapping(target = "active", source = "active")
    @Mapping(target = "phoneNumber", source = "phoneNumber")
    @Mapping(target = "location", source = "location")
    @Mapping(target = "plan", source = "plan")
    @Mapping(target = "password", ignore = true) // Password must be handled separately in the service
    public abstract User toUser(UserRequest request);

    @BeanMapping(ignoreByDefault = true)
    @Mapping(target = "id", source = "id")
    @Mapping(target = "fullName", source = "fullName")
    @Mapping(target = "email", source = "email")
    @Mapping(target = "phoneNumber", source = "phoneNumber")
    @Mapping(target = "location", source = "location")
    @Mapping(target = "plan", source = "plan")
    @Mapping(target = "onboardingCompleted", source = "onboardingCompleted")
    @Mapping(target = "avatarUrl", source = "avatarUrl")
    @Mapping(target = "active", source = "active")
    public abstract UserResponse toResponse(User user);

    @BeanMapping(ignoreByDefault = true)
    @Mapping(target = "fullName", source = "fullName")
    @Mapping(target = "email", source = "email")
    @Mapping(target = "avatarUrl", source = "avatarUrl")
    @Mapping(target = "active", source = "active")
    @Mapping(target = "phoneNumber", source = "phoneNumber")
    @Mapping(target = "location", source = "location")
    @Mapping(target = "plan", source = "plan")
    @Mapping(target = "password", ignore = true)
    public abstract void updateUserFromRequest(UserRequest request, @MappingTarget User user);
}