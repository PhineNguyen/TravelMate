package com.travelmate.backend.repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import com.travelmate.backend.entity.SharedTripInvite;

import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.enums.InviteStatus;

public interface SharedTripInviteRepository extends JpaRepository<SharedTripInvite, Long> {

    List<SharedTripInvite> findByTripId(Long tripId);

    List<SharedTripInvite> findBySenderId(Long senderId);

    List<SharedTripInvite> findByReceiverEmail(String receiverEmail);

    Optional<SharedTripInvite> findByInviteCode(String inviteCode);

    boolean existsByInviteCode(String inviteCode);

    List<SharedTripInvite> findByStatus(InviteStatus status);

    List<SharedTripInvite> findByTripIdAndStatus(Long tripId, InviteStatus status);

    List<SharedTripInvite> findByReceiverEmailAndStatus(String receiverEmail, InviteStatus status);

    List<SharedTripInvite> findByExpiresAtBefore(LocalDateTime time);

}
