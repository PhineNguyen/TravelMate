package com.travelmate.travelmate_backend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

@Entity
@Table(name = "tripTemplate")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class TripTemplate {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "title", nullable = false, length = 255)
    private String title;

    @Column(name = "destination", nullable = false, length = 255)
    private String destination;

    @Column(name = "category", nullable = false, length = 100)
    private String category;

    @Column(name = "duration")
    private Integer duration;

    @Column(name = "estimated_budget", precision = 12, scale = 2)
    private BigDecimal estimatedBudget;

    @Column(name = "thumbnail_url", length = 500)
    private String thumbnailUrl;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "popularity_score")
    private Double popularityScore;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

}
