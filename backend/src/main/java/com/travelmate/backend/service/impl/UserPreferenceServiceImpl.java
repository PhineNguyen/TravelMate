package com.travelmate.backend.service.impl;

import com.travelmate.backend.entity.User;
import com.travelmate.backend.entity.UserPreference;
import com.travelmate.backend.dto.UserPreferenceDTO;
import com.travelmate.backend.repository.UserPreferenceRepository;
import com.travelmate.backend.service.UserPreferenceService;
import com.travelmate.backend.mapper.UserPreferenceMapper;
import com.travelmate.backend.repository.UserRepository;

import jakarta.transaction.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserPreferenceServiceImpl implements UserPreferenceService {
    private final UserPreferenceRepository userPreferenceRepository;
    private final UserRepository userRepository;

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()
                || authentication.getPrincipal() == null) {
            throw new IllegalStateException("User not authenticated");
        }

        Object principal = authentication.getPrincipal();
        if (principal instanceof User user) {
            return user;
        }
        if (principal instanceof org.springframework.security.core.userdetails.UserDetails userDetails) {
            return userRepository.findByEmailAndActiveTrue(userDetails.getUsername())
                    .orElseThrow(() -> new IllegalStateException("Authenticated user not found in database"));
        }
        throw new IllegalStateException("Unsupported authentication principal type: "
                + principal.getClass().getName());
    }

    @Override
    @Transactional // đảm bảo chương trình được rollback nếu có lỗi xảy ra
    public UserPreferenceDTO create(UserPreferenceDTO dto) {
        if (dto == null) {
            throw new IllegalArgumentException("UserPreferenceDTO must not be null");
        }
        if (dto.getId() != null) {
            throw new IllegalArgumentException("Preference id must be null when creating");
        }

        User user = getCurrentUser();
        Long userId = user.getId();

        if (userPreferenceRepository.findByUserId(userId).isPresent()) {
            throw new IllegalArgumentException("Preference already exists");
        }
        BigDecimal minBudget = dto.getMinBudget();
        BigDecimal maxBudget = dto.getMaxBudget();
        validateBudget(minBudget, maxBudget);
        if (minBudget != null)
            minBudget = minBudget.setScale(2, RoundingMode.HALF_UP);
        if (maxBudget != null)
            maxBudget = maxBudget.setScale(2, RoundingMode.HALF_UP);

        Integer avgTripDays = dto.getAvgTripDays();
        validateAvgTripDays(avgTripDays);

        String preferredStyle = trimAndLimit(dto.getPreferredStyle(), 100);
        if (preferredStyle != null && preferredStyle.isEmpty())
            throw new IllegalArgumentException("PreferredStyle is required");
        String preferredRegion = trimAndLimit(dto.getPreferredRegion(), 100);
        if (preferredRegion != null && preferredRegion.isEmpty())
            throw new IllegalArgumentException("PreferredRegion is required");

        String favoriteCategories = trimToNull(dto.getFavoriteCategories());

        UserPreference pref = UserPreference.builder()
                .user(user)
                .minBudget(minBudget)
                .maxBudget(maxBudget)
                .avgTripDays(avgTripDays)
                .preferredStyle(preferredStyle)
                .favoriteCategories(favoriteCategories)
                .preferredRegion(preferredRegion)
                .build();

        try {
            UserPreference saved = userPreferenceRepository.save(pref);
            return UserPreferenceMapper.toDto(saved);
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public UserPreferenceDTO update(UserPreferenceDTO dto) {
        if (dto == null) {
            throw new IllegalArgumentException("UserPreferenceDTO must be not null");
        }
        if (dto.getId() == null) {
            throw new IllegalArgumentException("Id is required for update");
        }

        User currentUser = getCurrentUser();

        UserPreference existing = userPreferenceRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("Preference not found"));

        if (!existing.getUser().getId().equals(currentUser.getId())) {
            throw new AccessDeniedException("You can only update your own preferences");
        }

        // Budget
        BigDecimal minBudget = dto.getMinBudget() != null ? dto.getMinBudget() : existing.getMinBudget();
        BigDecimal maxBudget = dto.getMaxBudget() != null ? dto.getMaxBudget() : existing.getMaxBudget();
        validateBudget(minBudget, maxBudget);
        if (minBudget != null)
            minBudget = minBudget.setScale(2, RoundingMode.HALF_UP);
        if (maxBudget != null)
            maxBudget = maxBudget.setScale(2, RoundingMode.HALF_UP);
        existing.setMinBudget(minBudget);
        existing.setMaxBudget(maxBudget);

        // AverageTrip
        if (dto.getAvgTripDays() != null) {
            validateAvgTripDays(dto.getAvgTripDays());
            existing.setAvgTripDays(dto.getAvgTripDays());
        }

        // preferedStyle
        if (dto.getPreferredStyle() != null) {
            existing.setPreferredStyle(trimAndLimit(dto.getPreferredStyle(), 100));
        }
        // favoritedCategories
        if (dto.getFavoriteCategories() != null) {
            existing.setFavoriteCategories(trimToNull(dto.getFavoriteCategories()));
        }
        // perferedRegion
        if (dto.getPreferredRegion() != null) {
            existing.setPreferredRegion(trimAndLimit(dto.getPreferredRegion(), 100));
        }
        try {
            return UserPreferenceMapper.toDto(userPreferenceRepository.save(existing));
        } catch (DataIntegrityViolationException ex) { // DataIntegerityViolationExcepTion -> when database reject your
            // save
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public UserPreferenceDTO findByIdUser(Long userId) {
        if (userId == null) {
            throw new IllegalArgumentException("userId not found");
        }
        User currentUser = getCurrentUser();
        if (!currentUser.getId().equals(userId)) {
            throw new AccessDeniedException("You can only view your own preferences");
        }
        return userPreferenceRepository.findByUserId(userId)
                .map(UserPreferenceMapper::toDto)
                .orElse(null);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id is required");
        }

        User currentUser = getCurrentUser();
        UserPreference existing = userPreferenceRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Preference not found"));
        if (!existing.getUser().getId().equals(currentUser.getId())) {
            throw new AccessDeniedException("You can only delete your own preferences");
        }
        userPreferenceRepository.delete(existing);

    }

    private void validateBudget(BigDecimal minBudget, BigDecimal maxBudget) {
        if (minBudget != null && minBudget.signum() < 0) {
            throw new IllegalArgumentException("minBudget must be greater than or equal to zero");
        }
        if (maxBudget != null && maxBudget.signum() < 0) {
            throw new IllegalArgumentException("maxBudget must be greater than or equal to zero");
        }
        if (minBudget != null && maxBudget != null && minBudget.compareTo(maxBudget) > 0) {
            throw new IllegalArgumentException("minBudget must not be greater than maxBudget");
        }
    }

    private void validateAvgTripDays(Integer avgTripDays) {
        if (avgTripDays != null && (avgTripDays <= 0 || avgTripDays > 365)) {
            throw new IllegalArgumentException("avgTripDays must be between 1 and 365");
        }
    }

    private String trimToNull(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }

    private String trimAndLimit(String s, int maxLen) {
        String trimmed = trimToNull(s);
        if (trimmed == null) {
            return null;
        }
        if (trimmed.length() > maxLen) {
            throw new IllegalArgumentException("Value must not exceed " + maxLen + " characters");
        }
        return trimmed;
    }

}