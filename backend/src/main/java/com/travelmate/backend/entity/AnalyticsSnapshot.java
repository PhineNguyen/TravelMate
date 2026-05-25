package com.travelmate.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name = "analytics_snapshot", indexes = {
        @Index(name = "idx_analytics_trip_generated", columnList = "trip_id, generated_at")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AnalyticsSnapshot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trip_id", nullable = false)
    private Trip trip;

    @Column(name = "total_trips", nullable = false)
    private Integer totalTrips = 0;

    @Column(name = "avg_budget", precision = 12, scale = 2)
    private BigDecimal avgBudget;

    @Column(name = "total_spent", precision = 12, scale = 2)
    private BigDecimal totalSpent;

    @Column(name = "favorite_category", length = 100)
    private String favoriteCategory;

    @Column(name = "most_visited_destination", length = 255)
    private String mostVisitedDestination;

    @Column(name = "travel_personality", length = 100)
    private String travelPersonality;

    @CreationTimestamp
    @Column(name = "generated_at", nullable = false, updatable = false)
    private LocalDateTime generatedAt;
}