package com.travelmate.travelmate_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.travelmate.travelmate_backend.entity.enums.SourceType;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "itinerary_item", indexes = {
        @Index(name = "idx_itin_trip_day_order", columnList = "trip_id, day_number, order_index"),
        @Index(name = "idx_itin_place", columnList = "place_id")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ItineraryItem {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trip_id", nullable = false)
    private Trip tripId; // scalar for fast insert; or use @ManyToOne(fetch = LAZY) private Trip trip;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "place_id")
    private Place placeId; // keep scalar for perf; optional @ManyToOne(fetch = LAZY)

    @Column(name = "day_number", nullable = false)
    private Integer dayNumber;

    @Column(name = "start_time")
    private LocalTime startTime;

    @Column(name = "duration")
    private Integer duration; // minutes

    @Column(name = "note", columnDefinition = "TEXT")
    private String note;

    @Column(name = "cost_estimate", precision = 12, scale = 2)
    private BigDecimal costEstimate;

    @Column(name = "order_index", nullable = false)
    private Integer orderIndex;

    @Column(name = "source_type", length = 100)
    private SourceType sourceType;

    @Column(name = "is_locked", nullable = false)
    private boolean isLocked = false;

    @Column(name = "custom_type", length = 100)
    private String customType;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}