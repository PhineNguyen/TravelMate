package com.travelmate.backend.service;

import com.travelmate.backend.dto.request.ExpenseRequest;
import com.travelmate.backend.dto.response.ExpenseResponse;
import java.util.List;

public interface ExpenseService {
    ExpenseResponse create(ExpenseRequest dto);

    ExpenseResponse update(ExpenseRequest dto);

    ExpenseResponse findById(Long id);

    List<ExpenseResponse> listAll();

    void delete(Long id);
}
