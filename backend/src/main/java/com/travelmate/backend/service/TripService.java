package com.travelmate.backend.service;

import com.travelmate.backend.dto.request.TripRequest;
import com.travelmate.backend.dto.request.TripUpdateRequest;
import com.travelmate.backend.dto.request.TripItineraryGenerateRequest;
import com.travelmate.backend.dto.response.TripResponse;
import com.travelmate.backend.entity.enums.TripStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import com.travelmate.backend.dto.ItineraryItemDTO;

import java.util.List;

public interface TripService {

    TripResponse create(TripRequest dto);

    TripResponse findById(Long id);

    TripResponse update(TripUpdateRequest dto);

    List<TripResponse> listAll();

    Page<TripResponse> searchTrips(Long ownerId, TripStatus status, String destination, Pageable pageable);

    Page<TripResponse> getMyTrips(String view, Pageable pageable);

    void delete(Long id);

    TripResponse restore(Long id);

    List<ItineraryItemDTO> generateItineraryWithAI(Long id, TripItineraryGenerateRequest request);
}