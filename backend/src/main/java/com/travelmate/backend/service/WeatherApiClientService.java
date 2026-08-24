package com.travelmate.backend.service;

import com.travelmate.backend.dto.CurrentWeatherDTO;
import com.travelmate.backend.entity.Trip;

public interface WeatherApiClientService {
    void fetchAndProcessWeatherData(String city, Trip trip);

    CurrentWeatherDTO fetchCurrentWeather(double latitude, double longitude);
}