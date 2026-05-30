package com.travelmate.backend.controller;

import com.travelmate.backend.dto.MessageDTO;
import com.travelmate.backend.service.MessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/messages")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class MessageController {
    private final MessageService messageService;

    @PostMapping
    public ResponseEntity<MessageDTO> create(@Valid @RequestBody MessageDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(messageService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<MessageDTO> update(@PathVariable Long id, @Valid @RequestBody MessageDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(messageService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<MessageDTO> get(@PathVariable Long id) {
        MessageDTO m = messageService.findById(id);
        return m == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(m);
    }

    @GetMapping
    public ResponseEntity<List<MessageDTO>> list() {
        return ResponseEntity.ok(messageService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        messageService.delete(id);
        return ResponseEntity.noContent().build();
    }
}