package com.travelmate.backend.controller;

import com.travelmate.backend.dto.TripParticipantDTO;
import com.travelmate.backend.service.TripParticipantService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/trip-participants")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class TripParticipantController {
    private final TripParticipantService tripParticipantService;

    @PostMapping
    public ResponseEntity<TripParticipantDTO> create(@Valid @RequestBody TripParticipantDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(tripParticipantService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<TripParticipantDTO> update(@PathVariable Long id,
            @Valid @RequestBody TripParticipantDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(tripParticipantService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<TripParticipantDTO> get(@PathVariable Long id) {
        TripParticipantDTO dto = tripParticipantService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<TripParticipantDTO>> list() {
        return ResponseEntity.ok(tripParticipantService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        tripParticipantService.delete(id);
        return ResponseEntity.noContent().build();
    }
}