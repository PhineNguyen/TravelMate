package com.travelmate.backend.controller;

import com.travelmate.backend.dto.CurrentWeatherDTO;
import com.travelmate.backend.exception.ApiExceptionHandler;
import com.travelmate.backend.service.TripWeatherService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class WeatherControllerTest {
    @Mock TripWeatherService service;
    @InjectMocks WeatherController controller;
    MockMvc mvc;
    @BeforeEach void setup() {
        mvc = MockMvcBuilders.standaloneSetup(controller).setControllerAdvice(new ApiExceptionHandler()).build();
    }
    @Test void returnsTripWeather() throws Exception {
        when(service.getWeather(1L)).thenReturn(CurrentWeatherDTO.fallback(21.0, 105.0));
        mvc.perform(get("/api/weather/trip/1")).andExpect(status().isOk())
                .andExpect(jsonPath("$.latitude").value(21));
    }
    @Test void rejectsInvalidTripId() throws Exception {
        mvc.perform(get("/api/weather/trip/invalid")).andExpect(status().isBadRequest());
        verifyNoInteractions(service);
    }
    @Test void reportsMissingCoordinates() throws Exception {
        when(service.getWeather(1L)).thenThrow(new IllegalArgumentException("No coordinates"));
        mvc.perform(get("/api/weather/trip/1")).andExpect(status().isBadRequest());
    }
    @Test void rejectsOtherUsersTrip() throws Exception {
        when(service.getWeather(1L)).thenThrow(new org.springframework.security.access.AccessDeniedException("Denied"));
        mvc.perform(get("/api/weather/trip/1")).andExpect(status().isForbidden());
    }
}