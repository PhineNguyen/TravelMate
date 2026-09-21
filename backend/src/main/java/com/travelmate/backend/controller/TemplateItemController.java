package com.travelmate.backend.controller;

import com.travelmate.backend.dto.TemplateItemDTO;
import com.travelmate.backend.service.TemplateItemService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/template-items")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class TemplateItemController {
    private final TemplateItemService templateItemService;

    @GetMapping("/template/{id}")
    public ResponseEntity<List<TemplateItemDTO>> byTemplate(@PathVariable Long id) {
        return ResponseEntity.ok(templateItemService.findByTemplateId(id));
    }
}