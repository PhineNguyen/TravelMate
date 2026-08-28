package com.travelmate.backend.service;

import com.travelmate.backend.dto.UserPreferenceDTO;

public interface UserPreferenceService {
    UserPreferenceDTO create(UserPreferenceDTO dto);

    UserPreferenceDTO update(UserPreferenceDTO dto);

    UserPreferenceDTO findByIdUser(Long userId);

    void delete(Long id);
}
