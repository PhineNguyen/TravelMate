package com.travelmate.backend.service;

import com.travelmate.backend.dto.RoutePlanDTO;
import java.util.List;

public interface RoutePlanService {
    RoutePlanDTO create(RoutePlanDTO dto);

    RoutePlanDTO update(RoutePlanDTO dto);

    RoutePlanDTO findById(Long id);

    List<RoutePlanDTO> listAll();

    void delete(Long id);
}
