package com.travelmate.travelmate_backend.entity;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "userPreferences", indexes = {
        @Index(name = "idx_preference_user", columnList = "user_id")
})
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class UserPreference {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false, unique = true)
    private User user;

    @Column(name = "budget_range", precision = 12, scale = 2)
    private BigDecimal budgetRange;

    @Column(name = "avg_trip_days")
    private Integer avgTripDays;

    @Column(name = "preferred_style", length = 100)
    private String preferredStyle;

    @Column(name = "favorite_categories", columnDefinition = "TEXT")
    private String favoriteCategories;

    @Column(name = "preferred_region", length = 100)
    private String preferredRegion;

}
