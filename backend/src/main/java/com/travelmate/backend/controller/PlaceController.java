package com.travelmate.backend.controller;

import com.travelmate.backend.dto.PlaceDTO;
import com.travelmate.backend.service.PlaceService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/places")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class PlaceController {
    private final PlaceService placeService;

    @PostMapping
    public ResponseEntity<PlaceDTO> create(@Valid @RequestBody PlaceDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(placeService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<PlaceDTO> update(@PathVariable Long id, @Valid @RequestBody PlaceDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(placeService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<PlaceDTO> get(@PathVariable Long id) {
        PlaceDTO dto = placeService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<PlaceDTO>> list() {
        return ResponseEntity.ok(placeService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        placeService.delete(id);
        return ResponseEntity.noContent().build();
    }
}