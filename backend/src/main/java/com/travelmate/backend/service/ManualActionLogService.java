package com.travelmate.backend.service;

import com.travelmate.backend.dto.ManualActionLogDTO;
import java.util.List;

public interface ManualActionLogService {
    ManualActionLogDTO create(ManualActionLogDTO dto);

    ManualActionLogDTO update(ManualActionLogDTO dto);

    ManualActionLogDTO findById(Long id);

    List<ManualActionLogDTO> listAll();

    void delete(Long id);
}
