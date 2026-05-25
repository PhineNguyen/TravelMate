package com.travelmate.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;

import com.travelmate.backend.entity.enums.ManualActionType;

import java.time.LocalDateTime;

@Entity
@Table(name = "manual_action_log", indexes = {
        @Index(name = "idx_manual_action_trip_time", columnList = "trip_id, timestamp"),
        @Index(name = "idx_manual_action_user_time", columnList = "user_id, timestamp"),
        @Index(name = "idx_manual_action_target_time", columnList = "target_item_id, timestamp")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ManualActionLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trip_id", nullable = false)
    private Trip trip;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "target_item_id")
    private ItineraryItem targetItem;

    @Enumerated(EnumType.STRING)
    @Column(name = "action_type", nullable = false, length = 50)
    private ManualActionType actionType;

    @CreationTimestamp
    @Column(name = "timestamp", nullable = false, updatable = false)
    private LocalDateTime timestamp;
}