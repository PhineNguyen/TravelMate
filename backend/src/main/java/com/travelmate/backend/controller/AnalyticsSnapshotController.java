package com.travelmate.backend.controller;

import com.travelmate.backend.dto.AnalyticsSnapshotDTO;
import com.travelmate.backend.service.AnalyticsSnapshotService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/analytics-snapshots")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class AnalyticsSnapshotController {
    private final AnalyticsSnapshotService analyticsSnapshotService;

    @PostMapping
    public ResponseEntity<AnalyticsSnapshotDTO> create(@Valid @RequestBody AnalyticsSnapshotDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(analyticsSnapshotService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<AnalyticsSnapshotDTO> update(@PathVariable Long id,
            @Valid @RequestBody AnalyticsSnapshotDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(analyticsSnapshotService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<AnalyticsSnapshotDTO> get(@PathVariable Long id) {
        AnalyticsSnapshotDTO dto = analyticsSnapshotService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<AnalyticsSnapshotDTO>> list() {
        return ResponseEntity.ok(analyticsSnapshotService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        analyticsSnapshotService.delete(id);
        return ResponseEntity.noContent().build();
    }
}