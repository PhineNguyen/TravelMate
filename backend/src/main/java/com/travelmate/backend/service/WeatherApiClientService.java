package com.travelmate.backend.service;

import com.travelmate.backend.dto.CurrentWeatherDTO;

public interface WeatherApiClientService {
    CurrentWeatherDTO fetchCurrentWeather(double latitude, double longitude);
}