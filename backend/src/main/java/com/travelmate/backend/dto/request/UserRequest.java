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

    @Size(min = 6, message = "Password must be at least 6 characters")
    private String password;
}
