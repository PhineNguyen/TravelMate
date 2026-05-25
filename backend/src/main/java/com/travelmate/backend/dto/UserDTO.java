package com.travelmate.backend.dto;

import lombok.*;

@Data
@AllArgsConstructor
@Builder
public class UserDTO {
    private Long id;
    private String fullName;
    private String email;
    private String avatarUrl;
    private boolean active;
}