package com.travelmate.backend.mapper;

import com.travelmate.backend.dto.request.ExpenseRequest;
import com.travelmate.backend.dto.response.ExpenseResponse;
import com.travelmate.backend.entity.Expense;

public class ExpenseMapper {
    public static Expense toEntity(ExpenseRequest req) {
        if (req == null)
            return null;
        Expense e = new Expense();
        e.setAmount(req.getAmount());
        e.setCategory(req.getCategory());
        e.setDescription(req.getDescription());
        e.setShared(req.getIsShared() != null ? req.getIsShared() : false);
        return e;
    }

    public static ExpenseResponse toResponse(Expense e) {
        if (e == null)
            return null;
        return ExpenseResponse.builder()
                .id(e.getId())
                .tripId(e.getTrip() != null ? e.getTrip().getId() : null)
                .createdById(e.getCreatedBy() != null ? e.getCreatedBy().getId() : null)
                .amount(e.getAmount())
                .category(e.getCategory())
                .description(e.getDescription())
                .createdAt(e.getCreatedAt())
                .isShared(e.isShared())
                .build();
    }
}
