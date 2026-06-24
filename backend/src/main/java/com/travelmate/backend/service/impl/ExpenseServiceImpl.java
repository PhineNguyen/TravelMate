package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.request.ExpenseRequest;
import com.travelmate.backend.dto.response.ExpenseResponse;
import com.travelmate.backend.entity.enums.ExpenseCategory;
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
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.LocalDateTime;
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

        // ✅ ĐỒNG BỘ: Chỉ liên kết với Trip chưa bị xóa mềm
        Trip trip = tripRepository.findByIdAndIsDeletedFalse(dto.getTripId())
                .orElseThrow(() -> new IllegalArgumentException("Trip not found or has been deleted"));
        User user = userRepository.findById(dto.getCreatedById())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        Expense e = ExpenseMapper.toEntity(dto);
        e.setTrip(trip);
        e.setCreatedBy(user);

        // ✅ FIX THAY THẾ: Thay thế ROUND_HALF_UP đã bị deprecated bằng
        // RoundingMode.HALF_UP
        e.setAmount(dto.getAmount().setScale(2, RoundingMode.HALF_UP));

        // ✅ ĐỒNG BỘ (FR-BUDGET-02): Nếu đầu vào không chọn ngày, mặc định lấy ngày hôm
        // nay
        if (e.getExpenseDate() == null) {
            e.setExpenseDate(LocalDate.now());
        }

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

        // ✅ ĐỒNG BỘ: Không cho phép sửa hóa đơn đã bị xóa mềm
        Expense existing = expenseRepository.findByIdAndIsDeletedFalse(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("Expense not found or has been deleted"));

        if (dto.getAmount() != null) {
            if (dto.getAmount().compareTo(BigDecimal.ZERO) <= 0) {
                throw new IllegalArgumentException("amount must be > 0");
            }
            existing.setAmount(dto.getAmount().setScale(2, RoundingMode.HALF_UP));
        }
        if (dto.getCategory() != null)
            existing.setCategory(dto.getCategory());
        if (dto.getDescription() != null)
            existing.setDescription(dto.getDescription());
        if (dto.getIsShared() != null)
            existing.setShared(dto.getIsShared());

        // ✅ ĐỒNG BỘ: Hỗ trợ cập nhật ngày chi tiêu thực tế nếu có truyền lên
        if (dto.getExpenseDate() != null)
            existing.setExpenseDate(dto.getExpenseDate());

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
        // ✅ ĐỒNG BỘ: Chỉ tìm kiếm các hóa đơn chưa bị xóa mềm
        return expenseRepository.findByIdAndIsDeletedFalse(id)
                .map(ExpenseMapper::toResponse)
                .orElse(null);
    }

    @Override
    public List<ExpenseResponse> listAll() {
        // ✅ ĐỒNG BỘ: Chỉ trả về danh sách các hóa đơn chưa bị xóa mềm
        return expenseRepository.findAllByIsDeletedFalse(Pageable.unpaged())
                .getContent()
                .stream()
                .map(ExpenseMapper::toResponse)
                .collect(Collectors.toList());
    }

    @Override
    public Page<ExpenseResponse> searchExpenses(Long tripId, ExpenseCategory category, Pageable pageable) {
        Page<Expense> expensePage;

        // ✅ ĐỒNG BỘ: Logic lọc động kết hợp phân trang
        if (tripId != null && category != null) {
            expensePage = expenseRepository.findByTripIdAndCategoryAndIsDeletedFalse(tripId, category, pageable);
        } else if (tripId != null) {
            expensePage = expenseRepository.findByTripIdAndIsDeletedFalse(tripId, pageable);
        } else if (category != null) {
            expensePage = expenseRepository.findByCategoryAndIsDeletedFalse(category, pageable);
        } else {
            expensePage = expenseRepository.findAllByIsDeletedFalse(pageable);
        }

        return expensePage.map(ExpenseMapper::toResponse);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");

        // ✅ ĐỒNG BỘ LOGIC: Thực hiện gọi hàm update xóa mềm tối ưu dưới DB thay vì hard
        // delete
        int rowsAffected = expenseRepository.softDeleteById(id);
        if (rowsAffected == 0) {
            throw new IllegalArgumentException("Expense not found or already deleted");
        }
    }

    @Override
    @Transactional
    public ExpenseResponse restore(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");

        // Tìm bản ghi bất kể trạng thái xóa để khôi phục
        Expense expense = expenseRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Expense not found"));

        if (!expense.isDeleted()) {
            throw new IllegalArgumentException("Expense is not deleted");
        }

        // Đảo trạng thái xóa mềm
        expense.setDeleted(false);
        expense.setDeletedAt(null);

        return ExpenseMapper.toResponse(expenseRepository.save(expense));
    }
}