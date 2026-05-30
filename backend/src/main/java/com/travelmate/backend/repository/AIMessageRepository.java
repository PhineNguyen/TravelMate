package com.travelmate.backend.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.AIMessage;
import com.travelmate.backend.entity.enums.SenderType;

public interface AIMessageRepository extends JpaRepository<AIMessage, Long> {

    List<AIMessage> findByConversationIdOrderByCreatedAtAsc(Long conversationId);

    List<AIMessage> findByConversationIdAndSenderTypeOrderByCreatedAtAsc(Long conversationId, SenderType senderType);

    List<AIMessage> findByConversationIdAndCreatedAtAfterOrderByCreatedAtAsc(Long conversationId,
            LocalDateTime createdAt);

    List<AIMessage> findBySenderTypeOrderByCreatedAtDesc(SenderType senderType);

    long countByConversationId(Long conversationId);
}