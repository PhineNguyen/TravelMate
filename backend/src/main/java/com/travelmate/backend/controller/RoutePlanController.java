package com.travelmate.backend.controller;

import com.travelmate.backend.dto.RoutePlanDTO;
import com.travelmate.backend.service.RoutePlanService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/route-plans")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class RoutePlanController {
    private final RoutePlanService routePlanService;

    @PostMapping
    public ResponseEntity<RoutePlanDTO> create(@Valid @RequestBody RoutePlanDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(routePlanService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<RoutePlanDTO> update(@PathVariable Long id, @Valid @RequestBody RoutePlanDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(routePlanService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<RoutePlanDTO> get(@PathVariable Long id) {
        RoutePlanDTO dto = routePlanService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<RoutePlanDTO>> list() {
        return ResponseEntity.ok(routePlanService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        routePlanService.delete(id);
        return ResponseEntity.noContent().build();
    }
}