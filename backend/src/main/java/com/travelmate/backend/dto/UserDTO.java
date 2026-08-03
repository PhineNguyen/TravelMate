package com.travelmate.backend.dto;

import java.time.LocalDateTime;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserDTO {
    private Long id;
    private String fullName;
    private String email;
    private String phoneNumber;
    private String location;
    private String plan;
    private LocalDateTime createdAt;
    private String avatarUrl;
    private Boolean active;
}