package com.travelmate.backend.controller;

import com.travelmate.backend.dto.WeatherAlertDTO;
import com.travelmate.backend.service.WeatherAlertService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/weather-alerts")
@RequiredArgsConstructor
@Tag(name = "Weather Alerts", description = "Weather alerts and safety notifications endpoints")
public class WeatherAlertController {

    private final WeatherAlertService weatherAlertService;

    @Operation(
            description = "Retrieves all active and unresolved weather alerts for the specified trip."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Unresolved alerts list retrieved successfully")
    })
    @GetMapping("/trip/{tripId}/unresolved")
    public ResponseEntity<List<WeatherAlertDTO>> findUnresolvedByTripId(
            @Parameter(description = "Trip ID", example = "1", required = true)
            @PathVariable Long tripId) {
        return ResponseEntity.ok(weatherAlertService.findUnresolvedByTripId(tripId));
    }

    @Operation(
            description = "Retrieves all weather alerts (resolved and unresolved) for the specified trip."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Alerts list retrieved successfully")
    })
    @GetMapping("/trip/{tripId}")
    public ResponseEntity<List<WeatherAlertDTO>> findByTripId(
            @Parameter(description = "Trip ID", example = "1", required = true)
            @PathVariable Long tripId) {
        return ResponseEntity.ok(weatherAlertService.findByTripId(tripId));
    }

    @Operation(
            description = "Marks a specific weather alert as resolved with timestamp."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Alert resolved successfully"),
            @ApiResponse(responseCode = "400", description = "Weather alert not found")
    })
    @PutMapping("/{id}/resolve")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<WeatherAlertDTO> markResolved(
            @Parameter(description = "Weather alert ID to resolve", example = "1", required = true)
            @PathVariable Long id) {
        return ResponseEntity.ok(weatherAlertService.markResolved(id));
    }

    @Operation(
            description = "Retrieves details of a weather alert by ID."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Alert details retrieved successfully"),
            @ApiResponse(responseCode = "404", description = "Alert not found")
    })
    @GetMapping("/{id}")
    public ResponseEntity<WeatherAlertDTO> get(
            @Parameter(description = "Weather alert ID", example = "1", required = true)
            @PathVariable Long id) {
        WeatherAlertDTO dto = weatherAlertService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @Operation(
            description = "Retrieves all weather alert records in the system."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Alerts list retrieved successfully")
    })
    @GetMapping
    public ResponseEntity<List<WeatherAlertDTO>> list() {
        return ResponseEntity.ok(weatherAlertService.listAll());
    }

    @Operation(
            description = "Creates a new weather alert for a trip."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Weather alert created successfully"),
            @ApiResponse(responseCode = "400", description = "Invalid payload or missing required fields")
    })
    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<WeatherAlertDTO> create(@Valid @RequestBody WeatherAlertDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(weatherAlertService.create(dto));
    }

    @Operation(
            description = "Updates an existing weather alert by ID."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Alert updated successfully"),
            @ApiResponse(responseCode = "400", description = "Invalid payload or alert not found")
    })
    @PutMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<WeatherAlertDTO> update(
            @Parameter(description = "Weather alert ID to update", example = "1", required = true)
            @PathVariable Long id,
            @Valid @RequestBody WeatherAlertDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(weatherAlertService.update(dto));
    }

    @Operation(
            description = "Deletes a weather alert record by ID."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Alert deleted successfully"),
            @ApiResponse(responseCode = "400", description = "Alert not found")
    })
    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> delete(
            @Parameter(description = "Weather alert ID to delete", example = "1", required = true)
            @PathVariable Long id) {
        weatherAlertService.delete(id);
        return ResponseEntity.noContent().build();
    }
}

