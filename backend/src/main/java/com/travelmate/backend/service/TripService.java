package com.travelmate.backend.service;

import com.travelmate.backend.dto.request.TripRequest;
import com.travelmate.backend.dto.response.TripResponse;
import java.util.List;

public interface TripService {
    TripResponse create(TripRequest dto);

    TripResponse update(TripRequest dto);

    TripResponse findById(Long id);

    List<TripResponse> listAll();

    void delete(Long id);
}
