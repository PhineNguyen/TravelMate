package com.travelmate.backend.repository;

import java.time.Instant;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.AccessTokenRevocation;

public interface AccessTokenRevocationRepository extends JpaRepository<AccessTokenRevocation, Long> {
    Optional<AccessTokenRevocation> findByJti(String jti);

    boolean existsByJti(String jti);

    long deleteByExpiresAtBefore(Instant time);
}