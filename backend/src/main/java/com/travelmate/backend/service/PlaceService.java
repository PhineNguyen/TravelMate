package com.travelmate.backend.service;

import com.travelmate.backend.dto.PlaceDTO;
import java.util.List;

public interface PlaceService {
    PlaceDTO create(PlaceDTO dto);

    PlaceDTO update(PlaceDTO dto);

    PlaceDTO findById(Long id);

    List<PlaceDTO> listAll();

    void delete(Long id);
}
