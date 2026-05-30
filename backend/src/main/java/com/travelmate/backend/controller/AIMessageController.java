package com.travelmate.backend.controller;

import com.travelmate.backend.dto.AIMessageDTO;
import com.travelmate.backend.service.AIMessageService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/ai-messages")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class AIMessageController {
    private final AIMessageService aiMessageService;

    @PostMapping
    public ResponseEntity<AIMessageDTO> create(@Valid @RequestBody AIMessageDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(aiMessageService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<AIMessageDTO> update(@PathVariable Long id, @Valid @RequestBody AIMessageDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(aiMessageService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<AIMessageDTO> get(@PathVariable Long id) {
        AIMessageDTO dto = aiMessageService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<AIMessageDTO>> list() {
        return ResponseEntity.ok(aiMessageService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        aiMessageService.delete(id);
        return ResponseEntity.noContent().build();
    }
}