package com.travelmate.backend.controller;

import com.travelmate.backend.dto.CurrentWeatherDTO;
import com.travelmate.backend.service.WeatherApiClientService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/weather")
@RequiredArgsConstructor
public class WeatherController {
    private final WeatherApiClientService weatherApiClientService;

    @GetMapping("/current")
    public ResponseEntity<CurrentWeatherDTO> getCurrentWeather(
            @RequestParam double latitude,
            @RequestParam double longitude) {
        if (latitude < -90 || latitude > 90) {
            throw new IllegalArgumentException("Latitude must be between -90 and 90");
        }
        if (longitude < -180 || longitude > 180) {
            throw new IllegalArgumentException("Longitude must be between -180 and 180");
        }

        return ResponseEntity.ok(
                weatherApiClientService.fetchCurrentWeather(latitude, longitude));
    }
}