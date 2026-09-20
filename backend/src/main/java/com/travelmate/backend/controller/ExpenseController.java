package com.travelmate.backend.controller;

import com.travelmate.backend.dto.request.ExpenseRequest;
import com.travelmate.backend.dto.response.ExpenseResponse;
import com.travelmate.backend.entity.enums.ExpenseCategory;
import com.travelmate.backend.service.ExpenseService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/expenses")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class ExpenseController {
    private final ExpenseService expenseService;

    @GetMapping("/trip/{tripId}")
    public ResponseEntity<Page<ExpenseResponse>> list(@PathVariable Long tripId,
            @RequestParam(required = false) ExpenseCategory category,
            @PageableDefault(size = 10, sort = "expenseDate", direction = Sort.Direction.DESC) Pageable pageable) {
        return ResponseEntity.ok(expenseService.searchExpenses(tripId, category, pageable));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        expenseService.delete(id);
        return ResponseEntity.noContent().build();
    }

    @PostMapping
    public ResponseEntity<ExpenseResponse> create(@Valid @RequestBody ExpenseRequest dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(expenseService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ExpenseResponse> update(@PathVariable Long id, @Valid @RequestBody ExpenseRequest dto) {
        dto.setId(id);
        return ResponseEntity.ok(expenseService.update(dto));
    }

}
