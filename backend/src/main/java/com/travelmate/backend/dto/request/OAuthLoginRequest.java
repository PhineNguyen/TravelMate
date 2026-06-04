package com.travelmate.backend.dto.request;

import com.travelmate.backend.entity.enums.OAuthProvider;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class OAuthLoginRequest {
    @NotNull
    private OAuthProvider provider;

    @NotBlank
    private String providerUserId;

    @Email
    @NotBlank
    private String email;

    private String fullName;
    private String avatarUrl;
}
