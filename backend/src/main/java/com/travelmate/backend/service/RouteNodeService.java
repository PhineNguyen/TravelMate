package com.travelmate.backend.service;

import com.travelmate.backend.dto.RouteNodeDTO;
import java.util.List;

public interface RouteNodeService {
    RouteNodeDTO create(RouteNodeDTO dto);

    RouteNodeDTO update(RouteNodeDTO dto);

    RouteNodeDTO findById(Long id);

    List<RouteNodeDTO> listAll();

    void delete(Long id);
}
