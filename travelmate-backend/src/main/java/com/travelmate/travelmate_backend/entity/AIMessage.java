package com.travelmate.travelmate_backend.entity;

import jakarta.persistence.*;
import lombok.*;

import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.JdbcTypeCode;

import com.travelmate.travelmate_backend.entity.enums.SenderType;

import java.time.LocalDateTime;
import java.util.Map;
import java.io.Serializable;

@Entity
@Table(name = "ai_messages", indexes = {
        @Index(name = "idx_aimsg_conv", columnList = "conversation_id"),
        @Index(name = "idx_aimsg_created", columnList = "created_at")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AIMessage implements Serializable {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "conversation_id", nullable = false)
    private AIConversation conversation;

    @Enumerated(EnumType.STRING)
    @Column(name = "sender_type", length = 20, nullable = false)
    private SenderType senderType; // enum: USER, AI, SYSTEM

    @Lob
    @Column(name = "content", columnDefinition = "TEXT")
    private String content;

    @Column(name = "message_type", length = 50)
    private String messageType; // or enum if fixed set

    @Column(name = "token_used")
    private Integer tokenUsed;

    @Column(name = "model_name", length = 200)
    private String modelName;

    @Column(name = "response_time_ms")
    private Long responseTimeMs;

    @JdbcTypeCode(org.hibernate.type.SqlTypes.JSON)
    @Column(name = "context_data", columnDefinition = "jsonb")
    private Map<String, Object> contextData;

    @Column(name = "confidence_score")
    private Double confidenceScore;

    @CreationTimestamp
    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;
}