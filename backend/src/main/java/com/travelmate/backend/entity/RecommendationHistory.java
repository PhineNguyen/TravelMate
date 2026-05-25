package com.travelmate.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.Instant;

@Entity
@Table(name = "recommendation_history", indexes = {
        @Index(name = "idx_rec_hist_user_generated", columnList = "user_id, generated_at"),
        @Index(name = "idx_rec_hist_trip_generated", columnList = "trip_id, generated_at"),
        @Index(name = "idx_rec_hist_place", columnList = "place_id"),
        @Index(name = "idx_rec_hist_engine", columnList = "source_engine")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RecommendationHistory {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trip_id", nullable = false)
    private Trip trip;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "place_id")
    private Place place;

    @Column(name = "score", nullable = false)
    private Double score;

    @Column(name = "source_engine", length = 100, nullable = false)
    private String sourceEngine;

    @Column(name = "query_context", columnDefinition = "TEXT")
    private String queryContext;

    @Column(name = "recommendation_reason", columnDefinition = "TEXT")
    private String recommendationReason;

    @CreationTimestamp
    @Column(name = "generated_at", nullable = false, updatable = false)
    private Instant generatedAt;
}