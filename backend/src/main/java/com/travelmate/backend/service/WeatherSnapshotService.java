package com.travelmate.backend.service;

import com.travelmate.backend.dto.WeatherSnapshotDTO;
import java.util.List;

public interface WeatherSnapshotService {
    WeatherSnapshotDTO create(WeatherSnapshotDTO dto);

    WeatherSnapshotDTO update(WeatherSnapshotDTO dto);

    WeatherSnapshotDTO findById(Long id);

    WeatherSnapshotDTO findLatestByTripId(Long tripId);

    List<WeatherSnapshotDTO> listAll();

    void delete(Long id);
}
