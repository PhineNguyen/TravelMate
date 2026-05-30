package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.request.UserRequest;
import com.travelmate.backend.dto.response.UserResponse;
import com.travelmate.backend.mapper.UserMapper;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.service.UserService;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor; //tự tạo constructor cho tất cả các trường được đánh dấu là final hoặc @NonNull
import java.util.List;
import java.util.NoSuchElementException;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;

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
        User user = UserMapper.toEntity(dto);

        // set password if provided, else generate random
        if (dto.getPassword() != null && !dto.getPassword().isBlank()) {
            user.setPassword(passwordEncoder.encode(dto.getPassword()));
        } else {
            String rawPassword = UUID.randomUUID().toString();
            user.setPassword(passwordEncoder.encode(rawPassword));
        }

        User saved = userRepository.save(user);
        return UserMapper.toResponse(saved);
    }

    @Override
    @Transactional
    public UserResponse update(UserRequest dto) {
        if (dto == null) {
            throw new IllegalArgumentException("UserRequest must not be null");
        }
        if (dto.getId() == null) {
            throw new IllegalArgumentException("Id must not be null when update");
        }

        User user = userRepository.findById(dto.getId())
                .orElseThrow(() -> new NoSuchElementException("User not found with id: " + dto.getId()));

        if (dto.getEmail() != null && !dto.getEmail().isBlank()) {
            if (!dto.getEmail().equals(user.getEmail()) && userRepository.existsByEmail(dto.getEmail())) {
                throw new IllegalArgumentException("Email already exists");
            }
            user.setEmail(dto.getEmail());
        }

        if (dto.getFullName() != null) {
            user.setFullName(dto.getFullName());
        }
        if (dto.getAvatarUrl() != null) {
            user.setAvatarUrl(dto.getAvatarUrl());
        }
        if (dto.getActive() != null) {
            user.setActive(dto.getActive());
        }
        if (dto.getPassword() != null && !dto.getPassword().isBlank()) {
            user.setPassword(passwordEncoder.encode(dto.getPassword()));
        }

        User saved = userRepository.save(user);
        return UserMapper.toResponse(saved);
    }

    @Override
    public UserResponse findById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id must not be null");
        }

        User user = userRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("User not found with id: " + id));
        return UserMapper.toResponse(user);
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
                .map(UserMapper::toResponse)
                .collect(Collectors.toList());
    }

}
