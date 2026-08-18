package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.request.UserRequest;
import com.travelmate.backend.dto.response.UserResponse;
import com.travelmate.backend.mapper.UserMapper;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.service.UserService;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor; //tự tạo constructor cho tất cả các trường được đánh dấu là final hoặc @NonNull
import com.travelmate.backend.entity.User;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final UserMapper userMapper;

    @Override
    @Transactional
    public UserResponse create(UserRequest dto) {
        if (dto == null)
            throw new IllegalArgumentException("UserDTO must not be null");
        if (dto.getEmail() == null || dto.getEmail().isBlank()) {
            throw new IllegalArgumentException("Email is required");
        }
        if (userRepository.existsByEmail(dto.getEmail())) {
            throw new IllegalArgumentException("Email already exists");
        }
        User user = userMapper.toUser(dto);

        // set password if provided, else generate random
        if (dto.getPassword() != null && !dto.getPassword().isBlank()) {
            user.setPassword(passwordEncoder.encode(dto.getPassword()));
        } else {
            String rawPassword = UUID.randomUUID().toString();
            user.setPassword(passwordEncoder.encode(rawPassword));
        }

        User saved = userRepository.save(user);
        return userMapper.toResponse(saved);
    }

    @Override
    @Transactional
    public UserResponse update(Long id, UserRequest userRequest) {
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("User not found with id: " + id));

        // Check if email is being changed and if the new one is already taken
        if (userRequest.getEmail() != null && !userRequest.getEmail().isBlank()
                && !userRequest.getEmail().equals(user.getEmail())) {
            if (userRepository.existsByEmail(userRequest.getEmail())) {
                throw new IllegalArgumentException("Email already exists");
            }
        }

        // Use the mapper to update the entity from the request
        userMapper.updateUserFromRequest(userRequest, user);

        if (userRequest.getPassword() != null && !userRequest.getPassword().isBlank()) {
            user.setPassword(passwordEncoder.encode(userRequest.getPassword()));
        }

        return userMapper.toResponse(userRepository.save(user));
    }

    @Override
    public UserResponse findById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id must not be null");
        }

        User user = userRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("User not found with id: " + id));
        return userMapper.toResponse(user);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id must not be null");
        }

        if (!userRepository.existsById(id)) {
            throw new NoSuchElementException("User not found with id: " + id);
        }

        userRepository.deleteById(id);
    }

    @Override
    public List<UserResponse> listAll() {
        return userRepository.findByActiveTrue()
                .stream()
                .map(userMapper::toResponse)
                .collect(Collectors.toList());
    }

}
