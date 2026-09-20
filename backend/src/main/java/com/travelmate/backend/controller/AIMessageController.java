package com.travelmate.backend.controller;

import com.travelmate.backend.dto.AIMessageDTO;
import com.travelmate.backend.service.AIMessageService;
import com.travelmate.backend.dto.request.AIMessageSendRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ai-messages")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class AIMessageController {
    private final AIMessageService aiMessageService;

    @PostMapping("/send")
    public ResponseEntity<AIMessageDTO> sendMessage(@Valid @RequestBody AIMessageSendRequest request) {
        return ResponseEntity.ok(aiMessageService.sendMessage(request.getConversationId(), request.getContent()));
    }

}
