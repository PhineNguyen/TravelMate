package com.travelmate.backend.controller;

import com.travelmate.backend.dto.PlaceDTO;
import com.travelmate.backend.service.PlaceService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/places")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class PlaceController {
    private final PlaceService placeService;

    @PostMapping
    public ResponseEntity<PlaceDTO> create(@Valid @RequestBody PlaceDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(placeService.create(dto));
    }

    @GetMapping
    public ResponseEntity<List<PlaceDTO>> list(@RequestParam(required = false) String query) {
        return ResponseEntity.ok(placeService.search(query));
    }

}