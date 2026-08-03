package com.travelmate.backend.service;

import com.travelmate.backend.entity.Trip;

public interface WeatherApiClientService {
    void fetchAndProcessWeatherData(String city, Trip trip);
}