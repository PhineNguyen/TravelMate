package com.travelmate.backend.service;

import com.travelmate.backend.dto.ItineraryItemDTO;
import java.util.List;

public interface ItineraryItemService {
    ItineraryItemDTO create(ItineraryItemDTO dto);

    ItineraryItemDTO update(ItineraryItemDTO dto);

    ItineraryItemDTO findById(Long id);

    List<ItineraryItemDTO> listAll();

    void delete(Long id);
}
