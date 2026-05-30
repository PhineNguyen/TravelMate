package com.travelmate.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.AIConversation;

public interface AIConversationRepository extends JpaRepository<AIConversation, Long> {

    List<AIConversation> findByUser_Id(Long userId);

    List<AIConversation> findByTrip_Id(Long tripId);

    List<AIConversation> findByUser_IdOrderByCreatedAtDesc(Long userId);

    List<AIConversation> findByTrip_IdOrderByCreatedAtDesc(Long tripId);

    Optional<AIConversation> findTopByUser_IdOrderByUpdatedAtDesc(Long userId);

    Optional<AIConversation> findTopByTrip_IdOrderByUpdatedAtDesc(Long tripId);

    boolean existsByUser_IdAndTrip_Id(Long userId, Long tripId);
}