package com.travelmate.backend.controller;

import com.travelmate.backend.dto.CurrentWeatherDTO;
import com.travelmate.backend.service.WeatherApiClientService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/weather")
@RequiredArgsConstructor
@Tag(name = "Weather API", description = "Real-time weather data endpoints")
public class WeatherController {

    private final WeatherApiClientService weatherApiClientService;

    @Operation(
            description = "Fetches real-time weather details (temperature, humidity, wind speed, condition, outdoor safety) by latitude and longitude."
    )
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "Weather data retrieved successfully"),
            @ApiResponse(responseCode = "400", description = "Invalid GPS coordinates or missing parameters")
    })
    @GetMapping("/current")
    public ResponseEntity<CurrentWeatherDTO> getCurrentWeather(
            @Parameter(description = "GPS Latitude (-90.0 to 90.0)", example = "21.0285", required = true)
            @RequestParam double latitude,
            @Parameter(description = "GPS Longitude (-180.0 to 180.0)", example = "105.8542", required = true)
            @RequestParam double longitude) {
        if (Double.isNaN(latitude) || Double.isInfinite(latitude) || latitude < -90.0 || latitude > 90.0) {
            throw new IllegalArgumentException("Latitude must be between -90 and 90");
        }
        if (Double.isNaN(longitude) || Double.isInfinite(longitude) || longitude < -180.0 || longitude > 180.0) {
            throw new IllegalArgumentException("Longitude must be between -180 and 180");
        }

        return ResponseEntity.ok(
                weatherApiClientService.fetchCurrentWeather(latitude, longitude));
    }
}

