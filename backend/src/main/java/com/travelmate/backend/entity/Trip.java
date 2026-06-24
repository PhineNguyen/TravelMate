package com.travelmate.backend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import java.time.LocalDate;
import java.math.BigDecimal;

import org.hibernate.annotations.UpdateTimestamp;

import com.travelmate.backend.entity.enums.PlanningMode;
import com.travelmate.backend.entity.enums.TripStatus;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
@Table(name = "trips", indexes = {
        @Index(name = "idx_trip_owner", columnList = "owner_id"),
        @Index(name = "idx_trip_start_date", columnList = "start_date"),
        @Index(name = "idx_trip_invite_code", columnList = "invite_code")
})

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder

public class Trip {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id", nullable = false)
    private User owner;

    @Column(name = "destination", nullable = false, length = 255)
    private String destination;

    @Column(name = "start_date", nullable = false)
    private LocalDate startDate;

    @Column(name = "duration", nullable = false)
    private Integer duration;

    @Column(name = "traveler_count", nullable = false)
    private Integer travelerCount;

    @Column(name = "total_budget", precision = 12, scale = 2)
    private BigDecimal totalBudget;

    @Enumerated(EnumType.STRING)
    @Column(name = "planning_mode", nullable = false)
    private PlanningMode planningMode;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "template_id")
    private TripTemplate template;

    @Column(name = "is_customized", nullable = false)
    private boolean isCustomized = false;

    @Enumerated(EnumType.STRING)
    @Column(name = "trip_status", nullable = false)
    private TripStatus tripStatus;

    @Column(name = "invite_code", nullable = false, length = 100)
    private String inviteCode;

    @Column(name = "is_deleted", nullable = false)
    private boolean isDeleted = false;

    @Column(name = "deleted_at")
    private LocalDateTime deletedAt;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

}
