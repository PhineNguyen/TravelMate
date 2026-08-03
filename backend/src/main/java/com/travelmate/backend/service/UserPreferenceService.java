package com.travelmate.backend.service;

import com.travelmate.backend.dto.UserPreferenceDTO;

import java.util.List;

public interface UserPreferenceService {
    UserPreferenceDTO create(UserPreferenceDTO dto);

    UserPreferenceDTO update(UserPreferenceDTO dto);

    UserPreferenceDTO findByIdUser(Long userId);

    List<UserPreferenceDTO> listAll();

    void delete(Long id);
}
