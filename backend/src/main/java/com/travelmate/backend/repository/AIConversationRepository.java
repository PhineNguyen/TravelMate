package com.travelmate.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.AIConversation;

public interface AIConversationRepository extends JpaRepository<AIConversation, Long> {

    List<AIConversation> findByUserIdId(Long userId);

    List<AIConversation> findByTripIdId(Long tripId);

    List<AIConversation> findByUserIdIdOrderByCreatedAtDesc(Long userId);

    List<AIConversation> findByTripIdIdOrderByCreatedAtDesc(Long tripId);

    Optional<AIConversation> findTopByUserIdIdOrderByUpdatedAtDesc(Long userId);

    Optional<AIConversation> findTopByTripIdIdOrderByUpdatedAtDesc(Long tripId);

    boolean existsByUserIdIdAndTripIdId(Long userId, Long tripId);
}