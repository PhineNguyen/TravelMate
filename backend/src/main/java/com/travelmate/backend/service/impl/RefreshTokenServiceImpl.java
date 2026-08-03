package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.request.RefreshTokenRequest;
import com.travelmate.backend.dto.response.RefreshTokenResponse;
import com.travelmate.backend.mapper.RefreshTokenMapper;
import com.travelmate.backend.entity.RefreshToken;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.repository.RefreshTokenRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.service.RefreshTokenService;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class RefreshTokenServiceImpl implements RefreshTokenService {

    private final RefreshTokenRepository repository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public RefreshTokenResponse create(RefreshTokenRequest dto) {
        if (dto == null)
            throw new IllegalArgumentException("RefreshTokenRequest must not be null");
        if (dto.getUserId() == null)
            throw new IllegalArgumentException("userId is required");
        if (dto.getExpiryDate() == null)
            throw new IllegalArgumentException("expiryDate is required");

        User user = userRepository.findById(dto.getUserId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        RefreshToken t = RefreshTokenMapper.toEntity(dto);
        t.setUser(user);

        try {
            return RefreshTokenMapper.toResponse(repository.save(t));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public RefreshTokenResponse update(RefreshTokenRequest dto) {
        if (dto == null || dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");
        RefreshToken existing = repository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("RefreshToken not found"));
        if (dto.getExpiryDate() != null)
            existing.setExpiryDate(dto.getExpiryDate());
        if (dto.getRevoked() != null)
            existing.setRevoked(dto.getRevoked());

        try {
            return RefreshTokenMapper.toResponse(repository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public RefreshTokenResponse findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return repository.findById(id).map(RefreshTokenMapper::toResponse).orElse(null);
    }

    @Override
    public List<RefreshTokenResponse> listAll() {
        return repository.findAll().stream().map(RefreshTokenMapper::toResponse).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!repository.existsById(id))
            throw new IllegalArgumentException("RefreshToken not found");
        repository.deleteById(id);
    }

}
