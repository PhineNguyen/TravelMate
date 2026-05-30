package com.travelmate.backend.controller;

import com.travelmate.backend.dto.UserPreferenceDTO;
import com.travelmate.backend.service.UserPreferenceService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user-preferences")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class UserPreferenceController {
    private final UserPreferenceService userPreferenceService;

    @PostMapping
    public ResponseEntity<UserPreferenceDTO> create(@Valid @RequestBody UserPreferenceDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(userPreferenceService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<UserPreferenceDTO> update(@PathVariable Long id, @Valid @RequestBody UserPreferenceDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(userPreferenceService.update(dto));
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<UserPreferenceDTO> findByUserId(@PathVariable Long userId) {
        UserPreferenceDTO dto = userPreferenceService.findByIdUser(userId);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<UserPreferenceDTO>> list() {
        return ResponseEntity.ok(userPreferenceService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        userPreferenceService.delete(id);
        return ResponseEntity.noContent().build();
    }
}