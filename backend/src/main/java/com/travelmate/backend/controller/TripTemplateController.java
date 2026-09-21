package com.travelmate.backend.controller;

import com.travelmate.backend.dto.TripTemplateDTO;
import com.travelmate.backend.service.TripTemplateService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/trip-templates")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class TripTemplateController {
    private final TripTemplateService tripTemplateService;

    @GetMapping
    public ResponseEntity<List<TripTemplateDTO>> list() {
        return ResponseEntity.ok(tripTemplateService.listAll());
    }

}