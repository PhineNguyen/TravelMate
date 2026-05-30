package com.travelmate.backend.service;

import com.travelmate.backend.dto.AIMessageDTO;
import java.util.List;

public interface AIMessageService {
    AIMessageDTO create(AIMessageDTO dto);

    AIMessageDTO update(AIMessageDTO dto);

    AIMessageDTO findById(Long id);

    List<AIMessageDTO> listAll();

    void delete(Long id);
}
