package com.travelmate.backend.service;

import com.travelmate.backend.dto.NotificationDTO;
import java.util.List;

public interface NotificationService {
    NotificationDTO create(NotificationDTO dto);

    NotificationDTO update(NotificationDTO dto);

    NotificationDTO markRead(Long id, Long userId);

    void markAllRead(Long userId);

    NotificationDTO findById(Long id);

    List<NotificationDTO> listAll();

    void delete(Long id);
}
