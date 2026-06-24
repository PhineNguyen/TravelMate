package com.travelmate.backend.repository;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.transaction.annotation.Transactional;

import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.enums.TripStatus;

public interface TripRepository extends JpaRepository<Trip, Long> {

    // ==================== TRUY VẤN CƠ BẢN (CHƯA XÓA) ====================
    List<Trip> findAllByIsDeletedFalse();

    Page<Trip> findAllByIsDeletedFalse(Pageable pageable);

    Optional<Trip> findByIdAndIsDeletedFalse(Long id);

    boolean existsByIdAndIsDeletedFalse(Long id);

    // ==================== TRUY VẤN THEO OWNER (CHƯA XÓA) ====================
    List<Trip> findByOwnerIdAndIsDeletedFalse(Long ownerId);

    Page<Trip> findByOwnerIdAndIsDeletedFalse(Long ownerId, Pageable pageable);

    List<Trip> findByOwnerIdAndIsDeletedFalseOrderByCreatedAtDesc(Long ownerId);

    // ==================== TRUY VẤN THEO TRẠNG THÁI (CHƯA XÓA) ====================
    List<Trip> findByTripStatusAndIsDeletedFalse(TripStatus tripStatus);

    Page<Trip> findByTripStatusAndIsDeletedFalse(TripStatus tripStatus, Pageable pageable);

    List<Trip> findByOwnerIdAndTripStatusAndIsDeletedFalse(Long ownerId, TripStatus tripStatus);

    // ==================== TRUY VẤN THEO MÃ MỜI (CHƯA XÓA) ====================
    Optional<Trip> findByInviteCodeAndIsDeletedFalse(String inviteCode);

    boolean existsByInviteCodeAndIsDeletedFalse(String inviteCode);

    // ==================== BỘ LỌC ĐỊA ĐIỂM & THỜI GIAN (CHƯA XÓA)
    // ====================
    List<Trip> findByStartDateBetweenAndIsDeletedFalse(LocalDate from, LocalDate to);

    List<Trip> findByDestinationIgnoreCaseAndIsDeletedFalse(String destination);

    Page<Trip> findByDestinationIgnoreCaseAndIsDeletedFalse(String destination, Pageable pageable);

    // ==================== CUSTOM HÀNH ĐỘNG XÓA MỀM (SOFT DELETE)
    // ====================
    @Modifying
    @Transactional
    @Query("UPDATE Trip t SET t.isDeleted = true, t.deletedAt = CURRENT_TIMESTAMP WHERE t.id = :id AND t.isDeleted = false")
    int softDeleteById(@Param("id") Long id);

    // ==================== HÀM QUẢN TRỊ / BACKUP (GIỮ LẠI NẾU CẦN XEM CẢ DATA ĐÃ
    // XÓA) ====================
    List<Trip> findByOwnerId(Long ownerId);

    Page<Trip> findByOwnerId(Long ownerId, Pageable pageable);

    List<Trip> findByTripStatus(TripStatus tripStatus);

    Page<Trip> findByTripStatus(TripStatus tripStatus, Pageable pageable);

    List<Trip> findByOwnerIdAndTripStatus(Long ownerId, TripStatus tripStatus);

    Optional<Trip> findByInviteCode(String inviteCode);

    boolean existsByInviteCode(String inviteCode);

    List<Trip> findByStartDateBetween(LocalDate from, LocalDate to);

    Page<Trip> findByOwnerIdAndTripStatusAndIsDeletedFalse(Long ownerId, TripStatus tripStatus, Pageable pageable);

    List<Trip> findByDestinationIgnoreCase(String destination);

    Page<Trip> findByDestinationIgnoreCase(String destination, Pageable pageable);

    List<Trip> findByOwnerIdOrderByCreatedAtDesc(Long ownerId);
}