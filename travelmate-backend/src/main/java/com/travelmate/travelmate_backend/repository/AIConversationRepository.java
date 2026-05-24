package com.travelmate.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.AIConversation;

public interface AIConversationRepository extends JpaRepository<AIConversation, Long> {

    List<AIConversation> findByUserId(Long userId);

    List<AIConversation> findByTripId(Long tripId);

    List<AIConversation> findByUserIdOrderByCreatedAtDesc(Long userId);

    List<AIConversation> findByTripIdOrderByCreatedAtDesc(Long tripId);

    Optional<AIConversation> findTopByUserIdOrderByUpdatedAtDesc(Long userId);

    Optional<AIConversation> findTopByTripIdOrderByUpdatedAtDesc(Long tripId);

    boolean existsByUserIdIdAndTripIdId(Long userId, Long tripId);
}