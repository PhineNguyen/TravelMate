package com.travelmate.backend.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.enums.TripStatus;

public interface TripRepository extends JpaRepository<Trip, Long> {

    List<Trip> findAllByIsDeletedFalse();

    Optional<Trip> findByIdAndIsDeletedFalse(Long id);

    boolean existsByIdAndIsDeletedFalse(Long id);

    List<Trip> findByOwnerIdAndIsDeletedFalse(Long ownerId);

    List<Trip> findByOwnerId(Long ownerId);

    Page<Trip> findByOwnerId(Long ownerId, Pageable pageable);

    List<Trip> findByTripStatus(TripStatus tripStatus);

    Page<Trip> findByTripStatus(TripStatus tripStatus, Pageable pageable);

    List<Trip> findByOwnerIdAndTripStatus(Long ownerId, TripStatus tripStatus);

    Optional<Trip> findByInviteCode(String inviteCode);

    boolean existsByInviteCode(String inviteCode);

    List<Trip> findByStartDateBetween(LocalDate from, LocalDate to);

    List<Trip> findByDestinationIgnoreCase(String destination);

    Page<Trip> findByDestinationIgnoreCase(String destination, Pageable pageable);

    List<Trip> findByOwnerIdOrderByCreatedAtDesc(Long ownerId);

}
