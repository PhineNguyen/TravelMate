package com.travelmate.backend.controller;

import com.travelmate.backend.dto.AIConversationDTO;
import com.travelmate.backend.dto.request.AIConversationCreateRequest;

import com.travelmate.backend.service.AIConversationService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ai-conversations")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class AIConversationController {
    private final AIConversationService aiConversationService;

    @PostMapping
    public ResponseEntity<AIConversationDTO> create(@Valid @RequestBody AIConversationCreateRequest request) {
        AIConversationDTO dto = AIConversationDTO.builder()
                .userId(request.getUserId())
                .tripId(request.getTripId())
                .sessionTitle(request.getSessionTitle())
                .build();
        return ResponseEntity.status(HttpStatus.CREATED).body(aiConversationService.create(dto));
    }

    @GetMapping("/trip/{tripId}")
    public ResponseEntity<List<AIConversationDTO>> byTrip(@PathVariable Long tripId) {
        return ResponseEntity.ok(aiConversationService.findByTripId(tripId));
    }
}