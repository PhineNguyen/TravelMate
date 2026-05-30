package com.travelmate.backend.service;

import com.travelmate.backend.dto.SharedTripInviteDTO;
import java.util.List;

public interface SharedTripInviteService {
    SharedTripInviteDTO create(SharedTripInviteDTO dto);

    SharedTripInviteDTO update(SharedTripInviteDTO dto);

    SharedTripInviteDTO findById(Long id);

    List<SharedTripInviteDTO> listAll();

    void delete(Long id);
}
