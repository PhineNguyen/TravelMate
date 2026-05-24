package com.travelmate.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.ItineraryItem;

public interface ItineraryItemRepository extends JpaRepository<ItineraryItem, Long> {

    List<ItineraryItem> findByTripIdId(Long tripId);

    List<ItineraryItem> findByTripIdIdOrderByDayNumberAscOrderIndexAsc(Long tripId);

    List<ItineraryItem> findByTripIdIdAndDayNumberOrderByOrderIndexAsc(Long tripId, Integer dayNumber);

    List<ItineraryItem> findByPlaceIdId(Long placeId);

    List<ItineraryItem> findByTripIdIdAndIsLockedTrue(Long tripId);

    boolean existsByTripIdIdAndDayNumberAndOrderIndex(Long tripId, Integer dayNumber, Integer orderIndex);
}