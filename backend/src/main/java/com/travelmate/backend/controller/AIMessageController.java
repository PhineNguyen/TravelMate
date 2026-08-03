package com.travelmate.backend.controller;

import com.travelmate.backend.dto.AIMessageDTO;
import com.travelmate.backend.service.AIMessageService;
import com.travelmate.backend.dto.request.AIMessageSendRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ai-messages")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class AIMessageController {
    private final AIMessageService aiMessageService;

    /**
     * Gửi một tin nhắn từ người dùng đến AI và nhận lại phản hồi.
     * Đây là endpoint chính để tương tác với AI.
     */
    @PostMapping("/send")
    public ResponseEntity<AIMessageDTO> sendMessage(@Valid @RequestBody AIMessageSendRequest request) {
        AIMessageDTO dto = aiMessageService.sendMessage(request.getConversationId(), request.getContent());
        return ResponseEntity.ok(dto);
    }

    /**
     * Lấy thông tin chi tiết của một tin nhắn cụ thể bằng ID.
     */
    @GetMapping("/{id}")
    public ResponseEntity<AIMessageDTO> get(@PathVariable Long id) {
        AIMessageDTO dto = aiMessageService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    /**
     * Lấy lịch sử tin nhắn của một cuộc hội thoại.
     * Bạn có thể nâng cấp để hỗ trợ phân trang (Pageable) ở đây.
     */
    @GetMapping
    public ResponseEntity<List<AIMessageDTO>> listByConversation(@RequestParam Long conversationId) {
        List<AIMessageDTO> messages = aiMessageService.listByConversation(conversationId);
        return ResponseEntity.ok(messages);
    }
}