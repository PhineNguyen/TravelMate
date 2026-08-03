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
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserPreferenceServiceImpl implements UserPreferenceService {
    private final UserPreferenceRepository userPreferenceRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional // đảm bảo chương trình được rollback nếu có lỗi xảy ra
    public UserPreferenceDTO create(UserPreferenceDTO dto) {
        // validation input
        if (dto == null)
            throw new IllegalArgumentException("UserPreferenceDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("Preference Id must be not null ");
        Long userId = dto.getUserId();
        if (userId == null)
            throw new IllegalArgumentException("UserId is required");

        // available
        User user = userRepository.findById(userId).orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (userPreferenceRepository.findByUserId(userId).isPresent()) {
            throw new IllegalArgumentException("Preference already exists");
        }
        BigDecimal minBudget = dto.getMinBudget();
        BigDecimal maxBudget = dto.getMaxBudget();
        // signum method return the sign of the number
        // BigDecimal is a object
        if (minBudget != null && minBudget.signum() < 0)
            throw new IllegalArgumentException("Min budget must be greater than 0 and not null");
        if (maxBudget != null && maxBudget.signum() < 0)
            throw new IllegalArgumentException("Max budget must be greater than 0 and not null");
        if (minBudget != null && maxBudget != null && minBudget.compareTo(maxBudget) > 0) // -1 0 1
            throw new IllegalArgumentException("minBudget must be less than maxBudget");
        // round up
        if (minBudget != null)
            minBudget = minBudget.setScale(2, RoundingMode.HALF_UP);
        if (maxBudget != null)
            maxBudget = maxBudget.setScale(2, RoundingMode.HALF_UP);

        Integer avgTripDays = dto.getAvgTripDays();
        if (avgTripDays != null && (avgTripDays <= 0 || avgTripDays > 365))
            throw new IllegalArgumentException("average trip day must be between 0 and 365");

        String preferredStyle = trimAndLimit(dto.getPreferredStyle(), 100);
        if (preferredStyle != null && preferredStyle.isEmpty())
            throw new IllegalArgumentException("PreferredStyle is required");
        String preferredRegion = trimAndLimit(dto.getPreferredRegion(), 100);
        if (preferredRegion != null && preferredRegion.isEmpty())
            throw new IllegalArgumentException("PreferredRegion is required");

        String favoriteCategories = dto.getFavoriteCategories().trim();
        if (favoriteCategories != null && favoriteCategories.isBlank())
            throw new IllegalArgumentException("favoriteCategories is required");

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
        if (dto == null)
            throw new IllegalArgumentException("UserPreferenceDTO must be not null");
        if (dto.getId() == null)
            throw new IllegalArgumentException("Id is required for update");

        UserPreference existing = userPreferenceRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("Preference not found"));

        // Budget
        BigDecimal minBudget = dto.getMinBudget() != null ? dto.getMinBudget() : existing.getMinBudget();
        BigDecimal maxBudget = dto.getMaxBudget() != null ? dto.getMaxBudget() : existing.getMaxBudget();
        if (minBudget != null && minBudget.signum() < 0)
            throw new IllegalArgumentException("minBudget must be greater than 0");
        if (maxBudget != null && maxBudget.signum() < 0)
            throw new IllegalArgumentException("maxBudget must be greater than 0");
        if (minBudget != null && maxBudget != null && minBudget.compareTo(maxBudget) > 0)
            throw new IllegalArgumentException("minBudget must be less than maxBudget");
        if (minBudget != null)
            minBudget = minBudget.setScale(2, RoundingMode.HALF_UP);
        if (maxBudget != null)
            maxBudget = maxBudget.setScale(2, RoundingMode.HALF_UP);
        existing.setMinBudget(minBudget);
        existing.setMaxBudget(maxBudget);

        // AverageTrip
        if (dto.getAvgTripDays() != null) {
            int avgTripDays = dto.getAvgTripDays();
            if (avgTripDays <= 0 || avgTripDays > 365)
                throw new IllegalArgumentException("average trip day must be between 0 and 365");
            existing.setAvgTripDays(avgTripDays);
        }

        // preferedStyle
        if (dto.getPreferredStyle() != null) {
            String prefStyle = trimAndLimit(dto.getPreferredStyle(), 100);
            if (prefStyle.isEmpty())
                throw new IllegalArgumentException("Prefered style must not be empty");
            existing.setPreferredStyle(prefStyle);
        }
        // favoritedCategories
        if (dto.getFavoriteCategories() != null) {
            String favCategories = dto.getFavoriteCategories().trim();
            if (favCategories.isEmpty())
                throw new IllegalArgumentException("favorite category must be not null");
            existing.setFavoriteCategories(favCategories);
        }
        // perferedRegion
        if (dto.getPreferredRegion() != null) {
            String prefRegion = trimAndLimit(dto.getPreferredRegion(), 100);
            if (prefRegion.isEmpty())
                throw new IllegalArgumentException("Prefered region must not be empty");
            existing.setPreferredRegion(prefRegion);
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
        if (userId == null)
            throw new IllegalArgumentException("userId not found");
        return userPreferenceRepository.findByUserId(userId)
                .map(UserPreferenceMapper::toDto)
                .orElse(null);
    }

    @Override
    public List<UserPreferenceDTO> listAll() {
        return userPreferenceRepository.findAll()
                .stream()
                .map(UserPreferenceMapper::toDto)
                .collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("Id is required");
        if (!userPreferenceRepository.existsById(id)) {
            throw new IllegalArgumentException("Preference not found");
        }
        userPreferenceRepository.deleteById(id);

    }

    // length text limit
    private String trimAndLimit(String s, int maxLen) {
        if (s == null)
            return null;
        String t = s.trim();
        return t.length() <= maxLen ? t : t.substring(0, maxLen);
    }

}