package com.travelmate.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.TripParticipant;

public interface TripParticipantRepository extends JpaRepository<TripParticipant, Long> {

	List<TripParticipant> findByTripId(Long tripId);

	List<TripParticipant> findByUserId(Long userId);

	List<TripParticipant> findByTripIdAndIsActiveTrue(Long tripId);

	List<TripParticipant> findByUserIdAndIsActiveTrue(Long userId);

	Optional<TripParticipant> findByTripIdAndUserId(Long tripId, Long userId);

	boolean existsByTripIdAndUserId(Long tripId, Long userId);

	long countByTripIdAndIsActiveTrue(Long tripId);

	long countByUserIdAndIsActiveTrue(Long userId);

}
