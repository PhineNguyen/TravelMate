package com.travelmate.backend.repository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.travelmate.backend.entity.Expense;
import com.travelmate.backend.entity.enums.ExpenseCategory;

public interface ExpenseRepository extends JpaRepository<Expense, Long> {

    // ✅ ĐỒNG BỘ: Chỉ tìm các bản ghi chưa bị xóa mềm
    Optional<Expense> findByIdAndIsDeletedFalse(Long id);

    List<Expense> findByTripIdAndIsDeletedFalse(Long tripId);

    Page<Expense> findByTripIdAndIsDeletedFalse(Long tripId, Pageable pageable);

    List<Expense> findByCreatedByIdAndIsDeletedFalse(Long createdById);

    List<Expense> findByTripIdAndIsSharedTrueAndIsDeletedFalse(Long tripId);

    List<Expense> findByTripIdAndCategoryAndIsDeletedFalse(Long tripId, ExpenseCategory category);

    // Phục vụ hàm lọc động searchExpenses ở Controller (Lọc theo cả Trip
    // và Category kèm phân trang)
    Page<Expense> findByTripIdAndCategoryAndIsDeletedFalse(Long tripId, ExpenseCategory category, Pageable pageable);

    Page<Expense> findByCategoryAndIsDeletedFalse(ExpenseCategory category, Pageable pageable);

    Page<Expense> findAllByIsDeletedFalse(Pageable pageable);

    // Thay đổi sort theo ngày tiêu tiền thực tế (expenseDate) thay vì
    // ngày tạo log hệ thống
    List<Expense> findByTripIdAndIsDeletedFalseOrderByExpenseDateDesc(Long tripId);

    // Tìm kiếm chi tiêu nằm trong khoảng ngày tiêu tiền thực tế (Yêu
    // cầu FR-BUDGET-02)
    List<Expense> findByTripIdAndIsDeletedFalseAndExpenseDateBetween(Long tripId, LocalDate from, LocalDate to);

    // Tính tổng tiền của chuyến đi (Bỏ qua các khoản đã xóa mềm để tránh
    // sai số liệu)
    @Query("SELECT COALESCE(SUM(e.amount), 0) FROM Expense e WHERE e.trip.id = :tripId AND e.isDeleted = false")
    BigDecimal sumAmountByTripId(@Param("tripId") Long tripId);

    /**
     * Query xóa mềm tối ưu hiệu năng hạ tầng
     * Thay vì kéo Entity lên rồi set thuộc tính, câu lệnh này sẽ tác động trực tiếp
     * dưới DB
     */
    @Modifying
    @Query("UPDATE Expense e SET e.isDeleted = true, e.deletedAt = CURRENT_TIMESTAMP WHERE e.id = :id AND e.isDeleted = false")
    int softDeleteById(@Param("id") Long id);
}