package com.travelmate.travelmate_backend.entity;

import jakarta.persistence.*;
import lombok.*;

import org.hibernate.annotations.CreationTimestamp;

import com.travelmate.travelmate_backend.entity.enums.InviteStatus;

import java.time.LocalDateTime;

@Entity
@Table(name = "shared_trip_invites", indexes = {
        @Index(name = "idx_invite_trip", columnList = "trip_id"),
        @Index(name = "idx_invite_receiver", columnList = "receiver_email"),
        @Index(name = "idx_invite_code", columnList = "invite_code")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SharedTripInvite {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "trip_id", nullable = false)
    private Trip trip;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "sender_id", nullable = false)
    private User sender;

    @Column(name = "receiver_email", nullable = false, length = 320)
    private String receiverEmail;

    @Column(name = "invite_code", nullable = false, unique = true, length = 128)
    private String inviteCode;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false, length = 20)
    private InviteStatus status = InviteStatus.PENDING;

    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}