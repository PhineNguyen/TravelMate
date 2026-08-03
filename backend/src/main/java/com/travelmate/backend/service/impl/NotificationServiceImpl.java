package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.NotificationDTO;
import com.travelmate.backend.entity.Notification;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.repository.NotificationRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.service.NotificationService;
import com.travelmate.backend.mapper.NotificationMapper;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class NotificationServiceImpl implements NotificationService {

    private final NotificationRepository notificationRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public NotificationDTO create(NotificationDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("NotificationDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getUserId() == null)
            throw new IllegalArgumentException("userId is required");
        if (dto.getTitle() == null)
            throw new IllegalArgumentException("title is required");
        if (dto.getBody() == null)
            throw new IllegalArgumentException("body is required");

        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        Notification n = Notification.builder()
                .user(user)
                .title(dto.getTitle())
                .body(dto.getBody())
                .type(dto.getType())
                .isRead(dto.getIsRead() != null ? dto.getIsRead() : false)
                .build();

        try {
            return NotificationMapper.toDto(notificationRepository.save(n));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public NotificationDTO update(NotificationDTO dto) {
        if (dto == null || dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");
        Notification existing = notificationRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("Notification not found"));
        if (dto.getTitle() != null)
            existing.setTitle(dto.getTitle());
        if (dto.getBody() != null)
            existing.setBody(dto.getBody());
        if (dto.getType() != null)
            existing.setType(dto.getType());
        if (dto.getIsRead() != null)
            existing.setRead(dto.getIsRead());

        try {
            return NotificationMapper.toDto(notificationRepository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public NotificationDTO markRead(Long id, Long userId) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (userId == null)
            throw new IllegalArgumentException("userId is required");

        Notification existing = notificationRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Notification not found"));
        if (existing.getUser() == null || !userId.equals(existing.getUser().getId())) {
            throw new IllegalArgumentException("Notification does not belong to user");
        }
        existing.setRead(true);
        return NotificationMapper.toDto(notificationRepository.save(existing));
    }

    @Override
    @Transactional
    public void markAllRead(Long userId) {
        if (userId == null)
            throw new IllegalArgumentException("userId is required");

        List<Notification> notifications = notificationRepository
                .findByUserIdAndIsReadFalseOrderByCreatedAtDesc(userId);
        notifications.forEach(notification -> notification.setRead(true));
        notificationRepository.saveAll(notifications);
    }

    @Override
    public NotificationDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return notificationRepository.findById(id).map(NotificationMapper::toDto).orElse(null);
    }

    @Override
    public List<NotificationDTO> listAll() {
        return notificationRepository.findAll().stream().map(NotificationMapper::toDto).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!notificationRepository.existsById(id))
            throw new IllegalArgumentException("Notification not found");
        notificationRepository.deleteById(id);
    }

}
