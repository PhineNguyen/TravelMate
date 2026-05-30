package com.travelmate.backend.service;

import com.travelmate.backend.dto.TripParticipantDTO;
import java.util.List;

public interface TripParticipantService {
    TripParticipantDTO create(TripParticipantDTO dto);

    TripParticipantDTO update(TripParticipantDTO dto);

    TripParticipantDTO findById(Long id);

    List<TripParticipantDTO> listAll();

    void delete(Long id);
}
