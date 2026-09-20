package com.travelmate.backend.controller;

import com.travelmate.backend.dto.request.TripRequest;
import com.travelmate.backend.dto.request.TripUpdateRequest;
import com.travelmate.backend.dto.response.TripResponse;
import com.travelmate.backend.service.TripService;

import java.util.List;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/trips")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class TripController {
    private final TripService tripService;

    @PostMapping
    public ResponseEntity<TripResponse> create(@Valid @RequestBody TripRequest dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(tripService.create(dto));
    }
    @GetMapping
    public ResponseEntity<List<TripResponse>> list() {
        return ResponseEntity.ok(tripService.listAll());
    }
    @GetMapping("/{id}")
    public ResponseEntity<TripResponse> get(@PathVariable Long id) {
        TripResponse dto = tripService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @PutMapping("/{id}")
    public ResponseEntity<TripResponse> update(
            @PathVariable Long id,
            @Valid @RequestBody TripUpdateRequest dto) { // Dùng DTO mới và GIỮ LẠI @Valid
        dto.setId(id);
        return ResponseEntity.ok(tripService.update(dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        tripService.delete(id); // Service sẽ gọi repository.softDeleteById(id)
        return ResponseEntity.noContent().build();
    }

    @PutMapping("/{id}/restore")
    public ResponseEntity<TripResponse> restore(@PathVariable Long id) {
        TripResponse restoredTrip = tripService.restore(id);
        return ResponseEntity.ok(restoredTrip);
    }

}