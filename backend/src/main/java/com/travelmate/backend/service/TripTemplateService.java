package com.travelmate.backend.service;

import com.travelmate.backend.dto.TripTemplateDTO;
import java.util.List;

public interface TripTemplateService {
    TripTemplateDTO create(TripTemplateDTO dto);

    TripTemplateDTO update(TripTemplateDTO dto);

    TripTemplateDTO findById(Long id);

    List<TripTemplateDTO> listAll();

    void delete(Long id);
}
