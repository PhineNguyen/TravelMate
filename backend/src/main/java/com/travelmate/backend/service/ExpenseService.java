package com.travelmate.backend.service;

import com.travelmate.backend.dto.request.ExpenseRequest;
import com.travelmate.backend.dto.response.ExpenseResponse;
import com.travelmate.backend.entity.enums.ExpenseCategory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface ExpenseService {

    ExpenseResponse create(ExpenseRequest dto);

    ExpenseResponse update(ExpenseRequest dto);

    ExpenseResponse findById(Long id);

    List<ExpenseResponse> listAll();

    Page<ExpenseResponse> searchExpenses(Long tripId, ExpenseCategory category, Pageable pageable);

    void delete(Long id);

    ExpenseResponse restore(Long id);
}