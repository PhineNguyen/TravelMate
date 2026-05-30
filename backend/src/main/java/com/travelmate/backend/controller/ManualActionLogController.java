package com.travelmate.backend.controller;

import com.travelmate.backend.dto.ManualActionLogDTO;
import com.travelmate.backend.service.ManualActionLogService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/manual-action-logs")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class ManualActionLogController {
    private final ManualActionLogService manualActionLogService;

    @PostMapping
    public ResponseEntity<ManualActionLogDTO> create(@Valid @RequestBody ManualActionLogDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(manualActionLogService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<ManualActionLogDTO> update(@PathVariable Long id,
            @Valid @RequestBody ManualActionLogDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(manualActionLogService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<ManualActionLogDTO> get(@PathVariable Long id) {
        ManualActionLogDTO dto = manualActionLogService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<ManualActionLogDTO>> list() {
        return ResponseEntity.ok(manualActionLogService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        manualActionLogService.delete(id);
        return ResponseEntity.noContent().build();
    }
}