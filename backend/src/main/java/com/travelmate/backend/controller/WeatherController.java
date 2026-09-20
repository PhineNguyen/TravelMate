package com.travelmate.backend.controller;

import com.travelmate.backend.dto.CurrentWeatherDTO;
import com.travelmate.backend.service.TripWeatherService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/weather")
@RequiredArgsConstructor
public class WeatherController {
    private final TripWeatherService tripWeatherService;

    @GetMapping("/trip/{tripId}")
    public ResponseEntity<CurrentWeatherDTO> byTrip(@PathVariable Long tripId) {
        return ResponseEntity.ok(tripWeatherService.getWeather(tripId));
    }
}
