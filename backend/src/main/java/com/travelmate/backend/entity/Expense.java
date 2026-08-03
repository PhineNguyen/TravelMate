package com.travelmate.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

import com.travelmate.backend.entity.enums.ExpenseCategory;

@Entity
@Table(name = "expenses", indexes = {
        @Index(name = "idx_expense_trip", columnList = "trip_id"),
        @Index(name = "idx_expense_creator", columnList = "created_by"),
        @Index(name = "idx_expense_created", columnList = "created_at"),
        @Index(name = "idx_expense_date", columnList = "expense_date"), // ✅ BỔ SUNG: Index phục vụ việc sort/group chi
                                                                        // tiêu theo ngày
        @Index(name = "idx_expense_is_deleted", columnList = "is_deleted")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Expense {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trip_id", nullable = false)
    private Trip trip;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "created_by", nullable = false)
    private User createdBy;

    @Column(name = "amount", precision = 12, scale = 2, nullable = false)
    private BigDecimal amount;

    @Enumerated(EnumType.STRING)
    @Column(name = "category", length = 50)
    private ExpenseCategory category;

    @Lob
    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "expense_date", nullable = false)
    private LocalDate expenseDate;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "is_shared", nullable = false)
    private boolean isShared = false;

    @Builder.Default
    @Column(name = "is_deleted", nullable = false)
    private boolean isDeleted = false;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;
}