package com.travelmate.backend.controller;

import com.travelmate.backend.dto.SharedTripInviteDTO;
import com.travelmate.backend.service.SharedTripInviteService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/shared-trip-invites")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class SharedTripInviteController {
    private final SharedTripInviteService sharedTripInviteService;

    @PostMapping
    public ResponseEntity<SharedTripInviteDTO> create(@Valid @RequestBody SharedTripInviteDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(sharedTripInviteService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<SharedTripInviteDTO> update(@PathVariable Long id,
            @Valid @RequestBody SharedTripInviteDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(sharedTripInviteService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<SharedTripInviteDTO> get(@PathVariable Long id) {
        SharedTripInviteDTO dto = sharedTripInviteService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<SharedTripInviteDTO>> list() {
        return ResponseEntity.ok(sharedTripInviteService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        sharedTripInviteService.delete(id);
        return ResponseEntity.noContent().build();
    }
}