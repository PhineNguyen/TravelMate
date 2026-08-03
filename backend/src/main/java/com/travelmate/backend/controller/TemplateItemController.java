package com.travelmate.backend.controller;

import com.travelmate.backend.dto.TemplateItemDTO;
import com.travelmate.backend.service.TemplateItemService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/template-items")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class TemplateItemController {
    private final TemplateItemService templateItemService;

    @PostMapping
    public ResponseEntity<TemplateItemDTO> create(@Valid @RequestBody TemplateItemDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(templateItemService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<TemplateItemDTO> update(@PathVariable Long id, @Valid @RequestBody TemplateItemDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(templateItemService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<TemplateItemDTO> get(@PathVariable Long id) {
        TemplateItemDTO dto = templateItemService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<TemplateItemDTO>> list() {
        return ResponseEntity.ok(templateItemService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        templateItemService.delete(id);
        return ResponseEntity.noContent().build();
    }
}