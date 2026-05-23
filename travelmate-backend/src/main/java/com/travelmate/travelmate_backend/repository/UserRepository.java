package com.travelmate.travelmate_backend.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.travelmate_backend.entity.User;

public interface UserRepository extends JpaRepository<User, Long> {
}
