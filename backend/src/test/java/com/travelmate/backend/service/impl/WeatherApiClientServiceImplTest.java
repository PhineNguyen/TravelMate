package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.CurrentWeatherDTO;
import com.travelmate.backend.repository.WeatherAlertRepository;
import com.travelmate.backend.repository.WeatherSnapshotRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.client.MockRestServiceServer;
import org.springframework.web.client.RestClient;

import java.io.IOException;
import java.net.SocketTimeoutException;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.method;
import static org.springframework.test.web.client.match.MockRestRequestMatchers.requestTo;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withException;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withServerError;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withStatus;
import static org.springframework.test.web.client.response.MockRestResponseCreators.withSuccess;
import static org.springframework.http.HttpStatus.UNAUTHORIZED;

@ExtendWith(MockitoExtension.class)
class WeatherApiClientServiceImplTest {

    @Mock
    private WeatherAlertRepository weatherAlertRepository;

    @Mock
    private WeatherSnapshotRepository weatherSnapshotRepository;

    private WeatherApiClientServiceImpl weatherService;
    private MockRestServiceServer mockServer;

    @BeforeEach
    void setUp() {
        RestClient.Builder restClientBuilder = RestClient.builder();
        mockServer = MockRestServiceServer.bindTo(restClientBuilder).build();
        RestClient restClient = restClientBuilder.build();

        weatherService = new WeatherApiClientServiceImpl(
                restClient,
                weatherAlertRepository,
                weatherSnapshotRepository);

        ReflectionTestUtils.setField(weatherService, "apiKey", "test-api-key-123");
        ReflectionTestUtils.setField(weatherService, "apiUrl", "https://api.openweathermap.org/data/2.5");
    }

    @Test
    @DisplayName("fetchCurrentWeather should throw IllegalArgumentException when latitude is out of range [-90, 90]")
    void testFetchCurrentWeather_InvalidLatitude() {
        IllegalArgumentException exLow = assertThrows(IllegalArgumentException.class, () ->
                weatherService.fetchCurrentWeather(-90.1, 105.0));
        assertEquals("Latitude must be between -90 and 90", exLow.getMessage());

        IllegalArgumentException exHigh = assertThrows(IllegalArgumentException.class, () ->
                weatherService.fetchCurrentWeather(90.1, 105.0));
        assertEquals("Latitude must be between -90 and 90", exHigh.getMessage());
    }

    @Test
    @DisplayName("fetchCurrentWeather should throw IllegalArgumentException when longitude is out of range [-180, 180]")
    void testFetchCurrentWeather_InvalidLongitude() {
        IllegalArgumentException exLow = assertThrows(IllegalArgumentException.class, () ->
                weatherService.fetchCurrentWeather(21.0, -180.1));
        assertEquals("Longitude must be between -180 and 180", exLow.getMessage());

        IllegalArgumentException exHigh = assertThrows(IllegalArgumentException.class, () ->
                weatherService.fetchCurrentWeather(21.0, 180.1));
        assertEquals("Longitude must be between -180 and 180", exHigh.getMessage());
    }

    @Test
    @DisplayName("fetchCurrentWeather should return fallback safely when API key is missing or blank")
    void testFetchCurrentWeather_MissingApiKey() {
        ReflectionTestUtils.setField(weatherService, "apiKey", "");

        CurrentWeatherDTO result = weatherService.fetchCurrentWeather(21.0285, 105.8542);

        assertNotNull(result);
        assertEquals(21.0285, result.latitude());
        assertEquals(105.8542, result.longitude());
        assertEquals("Unknown", result.city());
        assertTrue(result.condition().contains("unavailable"));
    }

    @Test
    @DisplayName("fetchCurrentWeather should parse OpenWeatherMap response successfully")
    void testFetchCurrentWeather_Success() {
        String jsonResponse = """
                {
                    "coord": { "lon": 105.8542, "lat": 21.0285 },
                    "weather": [
                        { "id": 800, "main": "Clear", "description": "clear sky", "icon": "01d" }
                    ],
                    "main": {
                        "temp": 28.5,
                        "feels_like": 30.0,
                        "temp_min": 27.0,
                        "temp_max": 30.0,
                        "pressure": 1012,
                        "humidity": 60
                    },
                    "wind": { "speed": 3.2, "deg": 120 },
                    "name": "Hanoi",
                    "dt": 1690000000
                }
                """;

        mockServer.expect(requestTo("https://api.openweathermap.org/data/2.5/weather?lat=21.0285&lon=105.8542&appid=test-api-key-123&units=metric"))
                .andExpect(method(HttpMethod.GET))
                .andRespond(withSuccess(jsonResponse, MediaType.APPLICATION_JSON));

        CurrentWeatherDTO result = weatherService.fetchCurrentWeather(21.0285, 105.8542);

        assertNotNull(result);
        assertEquals("Hanoi", result.city());
        assertEquals(21.0285, result.latitude());
        assertEquals(105.8542, result.longitude());
        assertEquals(28.5, result.temperature());
        assertEquals(60.0, result.humidity());
        assertEquals(3.2, result.windSpeed());
        assertEquals("clear sky", result.condition());
        assertTrue(result.isOutdoorSafe());

        mockServer.verify();
    }

    @Test
    @DisplayName("fetchCurrentWeather should mark isOutdoorSafe as false when wind speed is high or condition is storm")
    void testFetchCurrentWeather_OutdoorUnsafe() {
        String jsonResponse = """
                {
                    "weather": [
                        { "id": 200, "main": "Thunderstorm", "description": "heavy thunderstorm", "icon": "11d" }
                    ],
                    "main": { "temp": 24.0, "humidity": 90 },
                    "wind": { "speed": 12.5 },
                    "name": "Da Nang",
                    "dt": 1690000000
                }
                """;

        mockServer.expect(requestTo("https://api.openweathermap.org/data/2.5/weather?lat=16.0544&lon=108.2022&appid=test-api-key-123&units=metric"))
                .andExpect(method(HttpMethod.GET))
                .andRespond(withSuccess(jsonResponse, MediaType.APPLICATION_JSON));

        CurrentWeatherDTO result = weatherService.fetchCurrentWeather(16.0544, 108.2022);

        assertNotNull(result);
        assertEquals("Da Nang", result.city());
        assertFalse(result.isOutdoorSafe());

        mockServer.verify();
    }

    @Test
    @DisplayName("fetchCurrentWeather should return fallback when OpenWeatherMap returns HTTP 500 error")
    void testFetchCurrentWeather_ServerErrorFallback() {
        mockServer.expect(requestTo("https://api.openweathermap.org/data/2.5/weather?lat=21.0285&lon=105.8542&appid=test-api-key-123&units=metric"))
                .andExpect(method(HttpMethod.GET))
                .andRespond(withServerError());

        CurrentWeatherDTO result = weatherService.fetchCurrentWeather(21.0285, 105.8542);

        assertNotNull(result);
        assertEquals("Unknown", result.city());
        assertEquals(21.0285, result.latitude());
        assertEquals(105.8542, result.longitude());

        mockServer.verify();
    }

    @Test
    @DisplayName("fetchCurrentWeather should return fallback when OpenWeatherMap returns HTTP 401 Unauthorized")
    void testFetchCurrentWeather_UnauthorizedFallback() {
        mockServer.expect(requestTo("https://api.openweathermap.org/data/2.5/weather?lat=21.0285&lon=105.8542&appid=test-api-key-123&units=metric"))
                .andExpect(method(HttpMethod.GET))
                .andRespond(withStatus(UNAUTHORIZED));

        CurrentWeatherDTO result = weatherService.fetchCurrentWeather(21.0285, 105.8542);

        assertNotNull(result);
        assertEquals("Unknown", result.city());

        mockServer.verify();
    }

    @Test
    @DisplayName("fetchCurrentWeather should return fallback when network times out without throwing exception")
    void testFetchCurrentWeather_TimeoutFallback() {
        mockServer.expect(requestTo("https://api.openweathermap.org/data/2.5/weather?lat=21.0285&lon=105.8542&appid=test-api-key-123&units=metric"))
                .andExpect(method(HttpMethod.GET))
                .andRespond(withException(new SocketTimeoutException("Read timed out")));

        CurrentWeatherDTO result = weatherService.fetchCurrentWeather(21.0285, 105.8542);

        assertNotNull(result);
        assertEquals("Unknown", result.city());
        assertEquals(21.0285, result.latitude());
        assertEquals(105.8542, result.longitude());

        mockServer.verify();
    }
}
