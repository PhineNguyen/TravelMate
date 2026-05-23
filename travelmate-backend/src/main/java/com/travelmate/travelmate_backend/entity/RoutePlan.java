package com.travelmate.travelmate_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import com.travelmate.travelmate_backend.entity.enums.StrategyType;

import java.time.LocalDateTime;

@Entity
@Table(name = "route_plan", indexes = {
        @Index(name = "idx_route_plan_trip_optimized", columnList = "trip_id, optimized_at"),
        @Index(name = "idx_route_plan_trip_strategy", columnList = "trip_id, strategy_type")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RoutePlan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trip_id", nullable = false)
    private Trip trip;

    @Enumerated(EnumType.STRING)
    @Column(name = "strategy_type", length = 100, nullable = false)
    private StrategyType strategyType;

    @Column(name = "total_distance")
    private Double totalDistance;

    @Column(name = "estimated_duration")
    private Integer estimatedDuration;

    @Column(name = "route_score")
    private Double routeScore;

    @CreationTimestamp
    @Column(name = "optimized_at", nullable = false, updatable = false)
    private LocalDateTime optimizedAt;
}