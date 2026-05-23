package com.travelmate.travelmate_backend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalTime;

@Entity
@Table(name = "template_item", indexes = {
                @Index(name = "idx_template_item_template_day_order", columnList = "template_id, day_number, order_index"),
                @Index(name = "idx_template_item_place", columnList = "place_id")
}, uniqueConstraints = {
                @UniqueConstraint(name = "uq_template_item_template_day_order", columnNames = { "template_id",
                                "day_number",
                                "order_index" })
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TemplateItem {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;

        @ManyToOne(fetch = FetchType.LAZY, optional = false)
        @JoinColumn(name = "template_id", nullable = false)
        private TripTemplate template;

        @ManyToOne(fetch = FetchType.LAZY, optional = false)
        @JoinColumn(name = "place_id", nullable = false)
        private Place place;

        @Column(name = "day_number", nullable = false)
        private Integer dayNumber;

        @Column(name = "order_index", nullable = false)
        private Integer orderIndex;

        @Column(name = "start_time")
        private LocalTime startTime;

        @Column(name = "duration")
        private Integer duration; // minutes

        @Column(name = "note", columnDefinition = "TEXT")
        private String note;

        @Column(name = "is_optional", nullable = false)
        private boolean isOptional = false;
}