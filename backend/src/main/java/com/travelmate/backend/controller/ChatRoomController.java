package com.travelmate.backend.controller;

import com.travelmate.backend.dto.ChatRoomDTO;
import com.travelmate.backend.service.ChatRoomService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/chat-rooms")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class ChatRoomController {
    private final ChatRoomService chatRoomService;

    @PostMapping
    public ResponseEntity<ChatRoomDTO> create(@Valid @RequestBody ChatRoomDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(chatRoomService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ChatRoomDTO> update(@PathVariable Long id, @Valid @RequestBody ChatRoomDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(chatRoomService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ChatRoomDTO> get(@PathVariable Long id) {
        ChatRoomDTO dto = chatRoomService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<ChatRoomDTO>> list() {
        return ResponseEntity.ok(chatRoomService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        chatRoomService.delete(id);
        return ResponseEntity.noContent().build();
    }
}