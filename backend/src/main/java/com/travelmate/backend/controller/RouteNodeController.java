package com.travelmate.backend.controller;

import com.travelmate.backend.dto.RouteNodeDTO;
import com.travelmate.backend.service.RouteNodeService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/route-nodes")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class RouteNodeController {
    private final RouteNodeService routeNodeService;

    @PostMapping
    public ResponseEntity<RouteNodeDTO> create(@Valid @RequestBody RouteNodeDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(routeNodeService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<RouteNodeDTO> update(@PathVariable Long id, @Valid @RequestBody RouteNodeDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(routeNodeService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<RouteNodeDTO> get(@PathVariable Long id) {
        RouteNodeDTO dto = routeNodeService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<RouteNodeDTO>> list() {
        return ResponseEntity.ok(routeNodeService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        routeNodeService.delete(id);
        return ResponseEntity.noContent().build();
    }
}