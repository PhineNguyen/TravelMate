package com.travelmate.backend.service;

import com.travelmate.backend.dto.CurrentWeatherDTO;
import com.travelmate.backend.entity.Place;
import com.travelmate.backend.repository.ItineraryItemRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class TripWeatherService {
    private final TripService tripService;
    private final ItineraryItemRepository items;
    private final WeatherApiClientService weather;

    @Transactional(readOnly = true)
    public CurrentWeatherDTO getWeather(Long tripId) {
        var trip = tripService.findById(tripId);
        int day = Math.max(1, (int) java.time.temporal.ChronoUnit.DAYS.between(
                trip.getStartDate(), java.time.LocalDate.now()) + 1);
        var candidates = items.findByTripIdOrderByDayNumberAscOrderIndexAsc(tripId);
        Place place = candidates.stream().filter(i -> i.getDayNumber() >= day)
                .map(i -> i.getPlace()).filter(this::hasCoordinates).findFirst()
                .orElseGet(() -> candidates.stream().map(i -> i.getPlace())
                        .filter(this::hasCoordinates).findFirst().orElseThrow(
                                () -> new IllegalArgumentException("Trip has no place with valid coordinates")));
        return weather.fetchCurrentWeather(place.getLatitude(), place.getLongitude());
    }

    private boolean hasCoordinates(Place place) {
        return place != null && place.getLatitude() != null && place.getLongitude() != null
                && Double.isFinite(place.getLatitude()) && Double.isFinite(place.getLongitude())
                && Math.abs(place.getLatitude()) <= 90 && Math.abs(place.getLongitude()) <= 180;
    }
}
