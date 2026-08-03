package com.travelmate.backend.controller;

import com.travelmate.backend.dto.WeatherAlertDTO;
import com.travelmate.backend.service.WeatherAlertService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/weather-alerts")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class WeatherAlertController {
    private final WeatherAlertService weatherAlertService;

    @PostMapping
    public ResponseEntity<WeatherAlertDTO> create(@Valid @RequestBody WeatherAlertDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(weatherAlertService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<WeatherAlertDTO> update(@PathVariable Long id, @Valid @RequestBody WeatherAlertDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(weatherAlertService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<WeatherAlertDTO> get(@PathVariable Long id) {
        WeatherAlertDTO dto = weatherAlertService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<WeatherAlertDTO>> list() {
        return ResponseEntity.ok(weatherAlertService.listAll());
    }

    @GetMapping("/trip/{tripId}")
    public ResponseEntity<List<WeatherAlertDTO>> findByTripId(@PathVariable Long tripId) {
        return ResponseEntity.ok(weatherAlertService.findByTripId(tripId));
    }

    @GetMapping("/trip/{tripId}/unresolved")
    public ResponseEntity<List<WeatherAlertDTO>> findUnresolvedByTripId(@PathVariable Long tripId) {
        return ResponseEntity.ok(weatherAlertService.findUnresolvedByTripId(tripId));
    }

    @PutMapping("/{id}/resolve")
    public ResponseEntity<WeatherAlertDTO> markResolved(@PathVariable Long id) {
        return ResponseEntity.ok(weatherAlertService.markResolved(id));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        weatherAlertService.delete(id);
        return ResponseEntity.noContent().build();
    }
}