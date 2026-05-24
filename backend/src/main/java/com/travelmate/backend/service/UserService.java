package com.travelmate.backend.service;

import com.travelmate.backend.dto.UserDTO;
import java.util.List;

public interface UserService {
    UserDTO create(UserDTO dto);

    List<UserDTO> listAll();
}
