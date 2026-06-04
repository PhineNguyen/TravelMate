package com.travelmate.backend.service.impl;

import com.travelmate.backend.entity.User;
import com.travelmate.backend.service.PasswordResetMailService;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
@RequiredArgsConstructor
public class PasswordResetMailServiceImpl implements PasswordResetMailService {
    private static final Logger log = LoggerFactory.getLogger(PasswordResetMailServiceImpl.class);

    private final JavaMailSender mailSender;

    @Value("${app.mail.enabled:false}")
    private boolean mailEnabled;

    @Value("${app.mail.from:no-reply@travelmate.local}")
    private String fromAddress;

    @Override
    public void sendResetMail(User user, String resetToken, LocalDateTime expiresAt) {
        String subject = "TravelMate password reset";
        String body = "Your password reset token is: " + resetToken + "\nExpires at: " + expiresAt;

        if (!mailEnabled) {
            log.info("Password reset mail for {}: {}", user.getEmail(), body);
            return;
        }

        SimpleMailMessage message = new SimpleMailMessage();
        message.setFrom(fromAddress);
        message.setTo(user.getEmail());
        message.setSubject(subject);
        message.setText(body);
        mailSender.send(message);
    }
}
