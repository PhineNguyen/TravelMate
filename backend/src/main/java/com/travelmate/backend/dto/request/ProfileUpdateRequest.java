package com.travelmate.backend.dto.request;

import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ProfileUpdateRequest {

    @Size(max = 200, message = "Full name must not exceed 200 characters")
    private String fullName;

    @Size(max = 1000, message = "Avatar URL must not exceed 1000 characters")
    private String avatarUrl;

    @Size(max = 20, message = "Phone number must not exceed 20 characters")
    private String phoneNumber;

    @Size(max = 200, message = "Location must not exceed 200 characters")
    private String location;
}