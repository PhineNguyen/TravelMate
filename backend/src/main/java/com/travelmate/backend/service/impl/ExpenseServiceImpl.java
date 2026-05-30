package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.request.ExpenseRequest;
import com.travelmate.backend.dto.response.ExpenseResponse;
import com.travelmate.backend.mapper.ExpenseMapper;
import com.travelmate.backend.entity.Expense;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.repository.ExpenseRepository;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.service.ExpenseService;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ExpenseServiceImpl implements ExpenseService {

    private final ExpenseRepository expenseRepository;
    private final TripRepository tripRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public ExpenseResponse create(ExpenseRequest dto) {
        if (dto == null)
            throw new IllegalArgumentException("ExpenseRequest must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getTripId() == null)
            throw new IllegalArgumentException("tripId is required");
        if (dto.getCreatedById() == null)
            throw new IllegalArgumentException("createdById is required");
        if (dto.getAmount() == null || dto.getAmount().compareTo(BigDecimal.ZERO) <= 0)
            throw new IllegalArgumentException("amount must be > 0");

        Trip trip = tripRepository.findById(dto.getTripId())
                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));
        User user = userRepository.findById(dto.getCreatedById())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        Expense e = ExpenseMapper.toEntity(dto);
        e.setTrip(trip);
        e.setCreatedBy(user);
        e.setAmount(dto.getAmount().setScale(2, BigDecimal.ROUND_HALF_UP));

        try {
            return ExpenseMapper.toResponse(expenseRepository.save(e));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public ExpenseResponse update(ExpenseRequest dto) {
        if (dto == null)
            throw new IllegalArgumentException("ExpenseRequest must not be null");
        if (dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");

        Expense existing = expenseRepository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("Expense not found"));

        if (dto.getAmount() != null)
            existing.setAmount(dto.getAmount().setScale(2, BigDecimal.ROUND_HALF_UP));
        if (dto.getCategory() != null)
            existing.setCategory(dto.getCategory());
        if (dto.getDescription() != null)
            existing.setDescription(dto.getDescription());
        if (dto.getIsShared() != null)
            existing.setShared(dto.getIsShared());

        try {
            return ExpenseMapper.toResponse(expenseRepository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    public ExpenseResponse findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return expenseRepository.findById(id).map(ExpenseMapper::toResponse).orElse(null);
    }

    @Override
    public List<ExpenseResponse> listAll() {
        return expenseRepository.findAll().stream().map(ExpenseMapper::toResponse).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!expenseRepository.existsById(id))
            throw new IllegalArgumentException("Expense not found");
        expenseRepository.deleteById(id);
    }

}
