package com.travelmate.backend.controller;

import com.travelmate.backend.dto.AIConversationDTO;
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
    public ResponseEntity<AIConversationDTO> create(@Valid @RequestBody AIConversationDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(aiConversationService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<AIConversationDTO> update(@PathVariable Long id, @Valid @RequestBody AIConversationDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(aiConversationService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<AIConversationDTO> get(@PathVariable Long id) {
        AIConversationDTO dto = aiConversationService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<AIConversationDTO>> list() {
        return ResponseEntity.ok(aiConversationService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        aiConversationService.delete(id);
        return ResponseEntity.noContent().build();
    }
}