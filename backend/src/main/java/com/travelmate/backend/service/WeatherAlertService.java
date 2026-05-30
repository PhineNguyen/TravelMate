package com.travelmate.backend.service;

import com.travelmate.backend.dto.WeatherAlertDTO;
import java.util.List;

public interface WeatherAlertService {
    WeatherAlertDTO create(WeatherAlertDTO dto);

    WeatherAlertDTO update(WeatherAlertDTO dto);

    WeatherAlertDTO findById(Long id);

    List<WeatherAlertDTO> findByTripId(Long tripId);

    List<WeatherAlertDTO> findUnresolvedByTripId(Long tripId);

    List<WeatherAlertDTO> listAll();

    void delete(Long id);

    WeatherAlertDTO markResolved(Long id);
}
