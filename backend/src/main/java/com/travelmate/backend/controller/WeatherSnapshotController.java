package com.travelmate.backend.controller;

import com.travelmate.backend.dto.WeatherSnapshotDTO;
import com.travelmate.backend.service.WeatherSnapshotService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/weather-snapshots")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class WeatherSnapshotController {
    private final WeatherSnapshotService weatherSnapshotService;

    @PostMapping
    public ResponseEntity<WeatherSnapshotDTO> create(@Valid @RequestBody WeatherSnapshotDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(weatherSnapshotService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<WeatherSnapshotDTO> update(@PathVariable Long id,
            @Valid @RequestBody WeatherSnapshotDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(weatherSnapshotService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<WeatherSnapshotDTO> get(@PathVariable Long id) {
        WeatherSnapshotDTO dto = weatherSnapshotService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<WeatherSnapshotDTO>> list() {
        return ResponseEntity.ok(weatherSnapshotService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        weatherSnapshotService.delete(id);
        return ResponseEntity.noContent().build();
    }
}