package com.travelmate.backend.repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import com.travelmate.backend.entity.Expense;
import com.travelmate.backend.entity.enums.ExpenseCategory;

public interface ExpenseRepository extends JpaRepository<Expense, Long> {

    List<Expense> findByTripId(Long tripId);

    Page<Expense> findByTripId(Long tripId, Pageable pageable);

    List<Expense> findByCreatedById(Long createdById);

    List<Expense> findByTripIdAndIsSharedTrue(Long tripId);

    List<Expense> findByTripIdAndCategory(Long tripId, ExpenseCategory category);

    List<Expense> findByTripIdOrderByCreatedAtDesc(Long tripId);

    List<Expense> findByTripIdAndCreatedAtBetween(Long tripId, LocalDateTime from, LocalDateTime to);

    @Query("SELECT COALESCE(SUM(e.amount), 0) FROM Expense e WHERE e.trip.id = :tripId")
    BigDecimal sumAmountByTripId(@Param("tripId") Long tripId);
}