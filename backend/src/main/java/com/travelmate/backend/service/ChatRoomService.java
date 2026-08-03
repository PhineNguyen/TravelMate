package com.travelmate.backend.service;

import com.travelmate.backend.dto.ChatRoomDTO;
import java.util.List;

public interface ChatRoomService {
    ChatRoomDTO create(ChatRoomDTO dto);

    ChatRoomDTO update(ChatRoomDTO dto);

    ChatRoomDTO findById(Long id);

    List<ChatRoomDTO> listAll();

    void delete(Long id);
}
