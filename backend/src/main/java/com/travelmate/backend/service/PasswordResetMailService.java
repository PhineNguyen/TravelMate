package com.travelmate.backend.service;

import com.travelmate.backend.entity.User;

import java.time.LocalDateTime;

public interface PasswordResetMailService {
    void sendResetMail(User user, String resetToken, LocalDateTime expiresAt);
}
