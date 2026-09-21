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

    @GetMapping("/{id}")
    public ResponseEntity<ItineraryItemDTO> get(@PathVariable Long id) {
        // Đã bỏ check null vì findById trong Service sẽ tự ném lỗi nếu không tìm thấy
        return ResponseEntity.ok(itineraryItemService.findById(id));
    }

    // Đã sửa lại thành @PathVariable để khớp với đường dẫn /trip/{tripId}
    @GetMapping("/trip/{tripId}")
    public ResponseEntity<List<ItineraryItemDTO>> getByTrip(@PathVariable Long tripId) {
        return ResponseEntity.ok(itineraryItemService.findByTripId(tripId));
    }

    @PutMapping("/reorder")
    public ResponseEntity<Void> reorder(@RequestBody List<ItineraryItemDTO> items) {
        itineraryItemService.reorder(items);
        return ResponseEntity.ok().build();
    }
    @PutMapping("/{id}")
    public ResponseEntity<ItineraryItemDTO> update(@PathVariable Long id, @Valid @RequestBody ItineraryItemDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(itineraryItemService.update(dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        itineraryItemService.delete(id);
        return ResponseEntity.noContent().build();
    }
}