package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.request.ProfileUpdateRequest;
import com.travelmate.backend.dto.request.UserRequest;
import com.travelmate.backend.dto.response.UserResponse;
import com.travelmate.backend.mapper.UserMapper;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.service.UserService;

import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.core.Authentication;

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

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated() || authentication.getPrincipal() == null) {
            throw new IllegalStateException("User not authenticated");
        }
        Object principal = authentication.getPrincipal();
        if (principal instanceof User user) {
            return user;
        }
        // JwtAuthenticationFilter sets a CustomUserDetails principal, not the User
        // entity
        if (principal instanceof org.springframework.security.core.userdetails.UserDetails userDetails) {
            return userRepository.findByEmailAndActiveTrue(userDetails.getUsername())
                    .orElseThrow(() -> new IllegalStateException("Authenticated user not found in database"));
        }
        throw new IllegalStateException("Unsupported authentication principal type: " + principal.getClass().getName());
    }

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
    public UserResponse update(Long id, ProfileUpdateRequest request) {
        if (id == null) {
            throw new IllegalArgumentException("User id must not be null");
        }

        if (request == null) {
            throw new IllegalArgumentException("Profile request must not be null");
        }

        User currentUser = getCurrentUser();

        if (!currentUser.getId().equals(id)) {
            throw new AccessDeniedException("You can only update your own profile");
        }

        if (request.getFullName() != null) {
            String fullName = request.getFullName().trim();

            if (fullName.isEmpty()) {
                throw new IllegalArgumentException(
                        "Full name must not be blank");
            }

            request.setFullName(fullName);
        }

        if (request.getPhoneNumber() != null) {
            request.setPhoneNumber(request.getPhoneNumber().trim());
        }

        if (request.getLocation() != null) {
            request.setLocation(request.getLocation().trim());
        }

        if (request.getAvatarUrl() != null) {
            request.setAvatarUrl(request.getAvatarUrl().trim());
        }
        User user = userRepository.findById(id)
                .orElseThrow(() -> new NoSuchElementException("User not found with id: " + id));

        userMapper.updateProfile(request, user);

        return userMapper.toResponse(userRepository.save(user));
    }

    @Override
    @Transactional
    public UserResponse completeOnboarding(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id must not be null");
        }

        User currentUser = getCurrentUser();
        if (!currentUser.getId().equals(id)) {
            throw new AccessDeniedException("You can only complete onboarding for your own account");
        }
        currentUser.setOnboardingCompleted(true);
        return userMapper.toResponse(userRepository.save(currentUser));
    }

    @Override
    public UserResponse findById(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id must not be null");
        }
        User currentUser = getCurrentUser();

        if (!currentUser.getId().equals(id)) {
            throw new AccessDeniedException(
                    "You can only view your own profile");
        }

        return userMapper.toResponse(currentUser);
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
