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

    @PostMapping
    public ResponseEntity<ExpenseResponse> create(@Valid @RequestBody ExpenseRequest dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(expenseService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ExpenseResponse> update(@PathVariable Long id, @Valid @RequestBody ExpenseRequest dto) {
        dto.setId(id);
        return ResponseEntity.ok(expenseService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ExpenseResponse> get(@PathVariable Long id) {
        ExpenseResponse dto = expenseService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    /**
     * Lấy danh sách chi tiêu hỗ trợ Phân trang, Sắp xếp và Bộ lọc động.
     * Cực kỳ hữu ích khi cần lấy toàn bộ chi phí thuộc về một chuyến đi (tripId).
     * URL ví dụ:
     * /api/expenses?tripId=1&category=FOOD&page=0&size=10&sort=expenseDate,desc
     */
    @GetMapping
    public ResponseEntity<Page<ExpenseResponse>> list(
            @RequestParam(required = false) Long tripId,
            @RequestParam(required = false) ExpenseCategory category,
            @PageableDefault(size = 10, sort = "expenseDate", direction = Sort.Direction.DESC) Pageable pageable) {

        Page<ExpenseResponse> expenses = expenseService.searchExpenses(tripId, category, pageable);
        return ResponseEntity.ok(expenses);
    }

    /**
     * ✅ THAY ĐỔI: Chuyển sang logic Xóa mềm (Soft Delete) thông qua Service.
     * Đánh dấu ẩn bản ghi chi tiêu chứ không xóa vật lý để đảm bảo toàn vẹn dữ liệu
     * thống kê.
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        expenseService.delete(id);
        return ResponseEntity.noContent().build();
    }

    /**
     * ✅ BỔ SUNG: Khôi phục khoản chi tiêu đã xóa mềm.
     * Giúp người dùng hoàn tác (Undo) nếu lỡ tay bấm xóa nhầm một khoản tiền.
     */
    @PutMapping("/{id}/restore")
    public ResponseEntity<ExpenseResponse> restore(@PathVariable Long id) {
        ExpenseResponse restoredExpense = expenseService.restore(id);
        return ResponseEntity.ok(restoredExpense);
    }
}