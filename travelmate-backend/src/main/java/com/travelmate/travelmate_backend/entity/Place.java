package com.travelmate.travelmate_backend.entity;

import jakarta.persistence.*;
import lombok.*;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import com.travelmate.travelmate_backend.entity.enums.ExpenseCategory;

import java.time.LocalDateTime;
import java.math.BigDecimal;

@Entity
@Table(name = "places", indexes = {
        @Index(name = "idx_place_city", columnList = "city"),
        @Index(name = "idx_place_category", columnList = "category"),
        @Index(name = "idx_place_is_active", columnList = "is_active")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Place {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "name", nullable = false, length = 255)
    private String name;

    @Column(name = "description", columnDefinition = "TEXT")
    private String description;

    @Column(name = "latitude")
    private Double latitude;

    @Column(name = "longitude")
    private Double longitude;

    @Column(name = "address", length = 500)
    private String address;

    @Column(name = "city", length = 100)
    private String city;

    @Column(name = "country", length = 100)
    private String country;

    @Enumerated(EnumType.STRING)
    @Column(name = "category", length = 100)
    private ExpenseCategory category;

    @Column(name = "rating")
    private Double rating;

    @Column(name = "review_count")
    private Integer reviewCount;

    @Column(name = "avg_cost", precision = 12, scale = 2)
    private BigDecimal avgCost;

    @Column(name = "currency", length = 3)
    private String currency;

    @Column(name = "is_indoor", nullable = false)
    private boolean isIndoor = false;

    @Column(name = "is_active", nullable = false)
    private boolean isActive = true;

    @Column(name = "image_url", length = 500)
    private String imageUrl;

    @Column(name = "phone_number", length = 50)
    private String phoneNumber;

    @Column(name = "website_url", length = 500)
    private String websiteUrl;

    @Column(name = "source_provider", length = 100)
    private String sourceProvider;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @UpdateTimestamp
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
}