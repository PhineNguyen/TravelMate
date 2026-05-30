package com.travelmate.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.ItineraryItem;

public interface ItineraryItemRepository extends JpaRepository<ItineraryItem, Long> {

    List<ItineraryItem> findByTripId(Long tripId);

    List<ItineraryItem> findByTripIdOrderByDayNumberAscOrderIndexAsc(Long tripId);

    List<ItineraryItem> findByTripIdAndDayNumberOrderByOrderIndexAsc(Long tripId, Integer dayNumber);

    List<ItineraryItem> findByPlaceId(Long placeId);

    List<ItineraryItem> findByTripIdAndIsLockedTrue(Long tripId);

    boolean existsByTripIdAndDayNumberAndOrderIndex(Long tripId, Integer dayNumber, Integer orderIndex);
}