package com.travelmate.backend.controller;

import com.travelmate.backend.dto.request.RefreshTokenRequest;
import com.travelmate.backend.dto.response.RefreshTokenResponse;
import com.travelmate.backend.service.RefreshTokenService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/refresh-tokens")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class RefreshTokenController {
    private final RefreshTokenService refreshTokenService;

    @PostMapping
    public ResponseEntity<RefreshTokenResponse> create(@Valid @RequestBody RefreshTokenRequest dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(refreshTokenService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<RefreshTokenResponse> update(@PathVariable Long id,
            @Valid @RequestBody RefreshTokenRequest dto) {
        dto.setId(id);
        return ResponseEntity.ok(refreshTokenService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<RefreshTokenResponse> get(@PathVariable Long id) {
        RefreshTokenResponse dto = refreshTokenService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @GetMapping
    public ResponseEntity<List<RefreshTokenResponse>> list() {
        return ResponseEntity.ok(refreshTokenService.listAll());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        refreshTokenService.delete(id);
        return ResponseEntity.noContent().build();
    }
}