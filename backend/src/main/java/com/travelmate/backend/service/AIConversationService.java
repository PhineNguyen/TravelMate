package com.travelmate.backend.service;

import com.travelmate.backend.dto.AIConversationDTO;
import java.util.List;

public interface AIConversationService {
    AIConversationDTO create(AIConversationDTO dto);

    AIConversationDTO update(AIConversationDTO dto);

    AIConversationDTO findById(Long id);

    List<AIConversationDTO> listAll();

    void delete(Long id);
}
