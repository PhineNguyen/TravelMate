package com.travelmate.backend.service;

import com.travelmate.backend.dto.MessageDTO;
import java.util.List;

public interface MessageService {
    MessageDTO create(MessageDTO dto);

    MessageDTO update(MessageDTO dto);

    MessageDTO findById(Long id);

    List<MessageDTO> listAll();

    void delete(Long id);
}
