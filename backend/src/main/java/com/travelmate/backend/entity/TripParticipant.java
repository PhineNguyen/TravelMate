package com.travelmate.backend.entity;

import jakarta.persistence.*;
import lombok.*;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;

import com.travelmate.backend.entity.enums.ParticipantRole;

@Entity
@Table(name = "trip_participants", indexes = {
                @Index(name = "idx_participant_trip", columnList = "trip_id"),
                @Index(name = "idx_participant_user", columnList = "user_id")
}, uniqueConstraints = {
                @UniqueConstraint(name = "uc_trip_user", columnNames = { "trip_id", "user_id" })
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TripParticipant {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;

        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "trip_id", nullable = false)
        private Trip trip;

        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "user_id", nullable = false)
        private User user;

        @Enumerated(EnumType.STRING)
        @Column(name = "role", length = 50, nullable = false)
        private ParticipantRole role;

        @CreationTimestamp
        @Column(name = "joined_at", updatable = false)
        private LocalDateTime joinedAt;

        @Column(name = "is_active", nullable = false)
        private boolean isActive = true; // soft-delete / left flag
}