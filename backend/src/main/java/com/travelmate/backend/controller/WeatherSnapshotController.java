package com.travelmate.backend.controller;

import com.travelmate.backend.dto.WeatherForecastDTO;
import com.travelmate.backend.dto.WeatherSnapshotDTO;
import com.travelmate.backend.service.WeatherSnapshotService;
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
@RequestMapping("/api/weather-snapshots")
@RequiredArgsConstructor
@Tag(name = "Weather Snapshots", description = "Trip weather snapshots and daily forecasts endpoints")
public class WeatherSnapshotController {

    private final WeatherSnapshotService weatherSnapshotService;

    @Operation(
            description = "Retrieves daily weather forecast items sorted by date for the specified trip."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Forecast list retrieved successfully")
    })
    @GetMapping("/trip/{tripId}/forecast")
    @PreAuthorize("permitAll()")
    public ResponseEntity<List<WeatherForecastDTO>> getForecast(
            @Parameter(description = "Trip ID", example = "1", required = true)
            @PathVariable Long tripId) {
        return ResponseEntity.ok(
                weatherSnapshotService.findForecastByTripId(tripId));
    }

    @Operation(
            description = "Retrieves the most recent weather snapshot of the specified trip."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Latest snapshot retrieved successfully"),
            @ApiResponse(responseCode = "404", description = "Snapshot not found for this trip")
    })
    @GetMapping("/trip/{tripId}")
    @PreAuthorize("permitAll()")
    public ResponseEntity<WeatherSnapshotDTO> getLatestByTrip(
            @Parameter(description = "Trip ID", example = "1", required = true)
            @PathVariable Long tripId) {
        WeatherSnapshotDTO dto = weatherSnapshotService.findLatestByTripId(tripId);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @Operation(
            description = "Retrieves details of a single weather snapshot by ID."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Snapshot details retrieved successfully"),
            @ApiResponse(responseCode = "404", description = "Snapshot not found")
    })
    @GetMapping("/{id}")
    @PreAuthorize("permitAll()")
    public ResponseEntity<WeatherSnapshotDTO> get(
            @Parameter(description = "WeatherSnapshot ID", example = "1", required = true)
            @PathVariable Long id) {
        WeatherSnapshotDTO dto = weatherSnapshotService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    @Operation(
            description = "Retrieves all weather snapshot records."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "List retrieved successfully")
    })
    @GetMapping
    @PreAuthorize("permitAll()")
    public ResponseEntity<List<WeatherSnapshotDTO>> list() {
        return ResponseEntity.ok(weatherSnapshotService.listAll());
    }

    @Operation(
            description = "Creates a new weather snapshot record for a trip."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "201", description = "Snapshot created successfully"),
            @ApiResponse(responseCode = "400", description = "Invalid payload or snapshot already exists for date")
    })
    @PostMapping
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<WeatherSnapshotDTO> create(@Valid @RequestBody WeatherSnapshotDTO dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(weatherSnapshotService.create(dto));
    }

    @Operation(
            description = "Updates an existing weather snapshot record by ID."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Snapshot updated successfully"),
            @ApiResponse(responseCode = "400", description = "Invalid payload"),
            @ApiResponse(responseCode = "404", description = "Snapshot not found")
    })
    @PutMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<WeatherSnapshotDTO> update(
            @Parameter(description = "WeatherSnapshot ID to update", example = "1", required = true)
            @PathVariable Long id,
            @Valid @RequestBody WeatherSnapshotDTO dto) {
        dto.setId(id);
        return ResponseEntity.ok(weatherSnapshotService.update(dto));
    }

    @Operation(
            description = "Deletes a weather snapshot record by ID."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "204", description = "Snapshot deleted successfully"),
            @ApiResponse(responseCode = "400", description = "Snapshot not found")
    })
    @DeleteMapping("/{id}")
    @PreAuthorize("isAuthenticated()")
    public ResponseEntity<Void> delete(
            @Parameter(description = "WeatherSnapshot ID to delete", example = "1", required = true)
            @PathVariable Long id) {
        weatherSnapshotService.delete(id);
        return ResponseEntity.noContent().build();
    }
}

