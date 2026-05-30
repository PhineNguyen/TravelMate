package com.travelmate.backend.controller;

import com.travelmate.backend.dto.ItineraryItemDTO;
import com.travelmate.backend.service.ItineraryItemService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/itinerary-items")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class ItineraryItemController {
    private final ItineraryItemService itineraryItemService;

    @PostMapping
    public ResponseEntity<ItineraryItemDTO> create(@Valid @RequestBody ItineraryItemDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(itineraryItemService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ItineraryItemDTO> update(@PathVariable Long id, @Valid @RequestBody ItineraryItemDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(itineraryItemService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ItineraryItemDTO> get(@PathVariable Long id) {
        ItineraryItemDTO dto = itineraryItemService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<ItineraryItemDTO>> list() {
        return ResponseEntity.ok(itineraryItemService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        itineraryItemService.delete(id);
        return ResponseEntity.noContent().build();
    }
}