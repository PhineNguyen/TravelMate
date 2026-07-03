package com.travelmate.backend.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserRequest {
    private Long id;
    private String fullName;

    @Email
    private String email;

    private String avatarUrl;

    private Boolean active;
    private String phoneNumber;
    private String location;
    private String plan;
    @Size(min = 8, message = "Password must be at least 8 characters")
    private String password;
}
