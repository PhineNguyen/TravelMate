package com.travelmate.travelmate_backend.service;

import com.travelmate.travelmate_backend.dto.UserDTO;
import java.util.List;

public interface UserService {
    UserDTO create(UserDTO dto);

    List<UserDTO> listAll();
}
