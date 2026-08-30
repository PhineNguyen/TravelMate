package com.travelmate.backend.controller;

import com.travelmate.backend.dto.CurrentWeatherDTO;
import com.travelmate.backend.exception.ApiExceptionHandler;
import com.travelmate.backend.service.WeatherApiClientService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import java.time.Instant;

import static org.mockito.ArgumentMatchers.anyDouble;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ExtendWith(MockitoExtension.class)
class WeatherControllerTest {

    private MockMvc mockMvc;

    @Mock
    private WeatherApiClientService weatherApiClientService;

    @InjectMocks
    private WeatherController weatherController;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(weatherController)
                .setControllerAdvice(new ApiExceptionHandler())
                .build();
    }

    @Test
    @DisplayName("GET /api/weather/current should return 200 and weather data for valid coordinates")
    void testGetCurrentWeather_ValidCoordinates() throws Exception {
        CurrentWeatherDTO mockDto = new CurrentWeatherDTO(
                21.0285,
                105.8542,
                "Hanoi",
                28.5,
                65.0,
                3.5,
                0.0,
                "scattered clouds",
                true,
                Instant.now());

        when(weatherApiClientService.fetchCurrentWeather(21.0285, 105.8542)).thenReturn(mockDto);

        mockMvc.perform(get("/api/weather/current")
                        .param("latitude", "21.0285")
                        .param("longitude", "105.8542"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.city").value("Hanoi"))
                .andExpect(jsonPath("$.latitude").value(21.0285))
                .andExpect(jsonPath("$.longitude").value(105.8542))
                .andExpect(jsonPath("$.temperature").value(28.5))
                .andExpect(jsonPath("$.humidity").value(65.0))
                .andExpect(jsonPath("$.windSpeed").value(3.5))
                .andExpect(jsonPath("$.condition").value("scattered clouds"))
                .andExpect(jsonPath("$.isOutdoorSafe").value(true));

        verify(weatherApiClientService).fetchCurrentWeather(21.0285, 105.8542);
    }

    @Test
    @DisplayName("GET /api/weather/current should return 400 Bad Request when latitude is less than -90")
    void testGetCurrentWeather_LatitudeTooLow() throws Exception {
        mockMvc.perform(get("/api/weather/current")
                        .param("latitude", "-90.1")
                        .param("longitude", "105.8542"))
                .andExpect(status().isBadRequest());

        verify(weatherApiClientService, never()).fetchCurrentWeather(anyDouble(), anyDouble());
    }

    @Test
    @DisplayName("GET /api/weather/current should return 400 Bad Request when latitude is greater than 90")
    void testGetCurrentWeather_LatitudeTooHigh() throws Exception {
        mockMvc.perform(get("/api/weather/current")
                        .param("latitude", "90.5")
                        .param("longitude", "105.8542"))
                .andExpect(status().isBadRequest());

        verify(weatherApiClientService, never()).fetchCurrentWeather(anyDouble(), anyDouble());
    }

    @Test
    @DisplayName("GET /api/weather/current should return 400 Bad Request when longitude is less than -180")
    void testGetCurrentWeather_LongitudeTooLow() throws Exception {
        mockMvc.perform(get("/api/weather/current")
                        .param("latitude", "21.0285")
                        .param("longitude", "-180.1"))
                .andExpect(status().isBadRequest());

        verify(weatherApiClientService, never()).fetchCurrentWeather(anyDouble(), anyDouble());
    }

    @Test
    @DisplayName("GET /api/weather/current should return 400 Bad Request when longitude is greater than 180")
    void testGetCurrentWeather_LongitudeTooHigh() throws Exception {
        mockMvc.perform(get("/api/weather/current")
                        .param("latitude", "21.0285")
                        .param("longitude", "180.1"))
                .andExpect(status().isBadRequest());

        verify(weatherApiClientService, never()).fetchCurrentWeather(anyDouble(), anyDouble());
    }

    @Test
    @DisplayName("GET /api/weather/current should return 400 when coordinates are missing")
    void testGetCurrentWeather_MissingParams() throws Exception {
        mockMvc.perform(get("/api/weather/current"))
                .andExpect(status().isBadRequest());

        verify(weatherApiClientService, never()).fetchCurrentWeather(anyDouble(), anyDouble());
    }
}
