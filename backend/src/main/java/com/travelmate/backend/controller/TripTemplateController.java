package com.travelmate.backend.controller;

import com.travelmate.backend.dto.TripTemplateDTO;
import com.travelmate.backend.service.TripTemplateService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/trip-templates")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class TripTemplateController {
    private final TripTemplateService tripTemplateService;

    @PostMapping
    public ResponseEntity<TripTemplateDTO> create(@Valid @RequestBody TripTemplateDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(tripTemplateService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<TripTemplateDTO> update(@PathVariable Long id, @Valid @RequestBody TripTemplateDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(tripTemplateService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<TripTemplateDTO> get(@PathVariable Long id) {
        TripTemplateDTO dto = tripTemplateService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<TripTemplateDTO>> list() {
        return ResponseEntity.ok(tripTemplateService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        tripTemplateService.delete(id);
        return ResponseEntity.noContent().build();
    }
}