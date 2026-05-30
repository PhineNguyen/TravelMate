package com.travelmate.backend.controller;

import com.travelmate.backend.dto.RecommendationHistoryDTO;
import com.travelmate.backend.service.RecommendationHistoryService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/recommendation-histories")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class RecommendationHistoryController {
    private final RecommendationHistoryService recommendationHistoryService;

    @PostMapping
    public ResponseEntity<RecommendationHistoryDTO> create(@Valid @RequestBody RecommendationHistoryDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(recommendationHistoryService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<RecommendationHistoryDTO> update(@PathVariable Long id,
            @Valid @RequestBody RecommendationHistoryDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(recommendationHistoryService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<RecommendationHistoryDTO> get(@PathVariable Long id) {
        RecommendationHistoryDTO dto = recommendationHistoryService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<RecommendationHistoryDTO>> list() {
        return ResponseEntity.ok(recommendationHistoryService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        recommendationHistoryService.delete(id);
        return ResponseEntity.noContent().build();
    }
}