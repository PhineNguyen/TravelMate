package com.travelmate.backend.repository;

import java.util.List;
import java.util.Optional;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.Place;
import com.travelmate.backend.entity.enums.ExpenseCategory;

public interface PlaceRepository extends JpaRepository<Place, Long> {

    Optional<Place> findByNameAndCityAndCountry(String name, String city, String country);

    boolean existsByNameAndCityAndCountry(String name, String city, String country);

    List<Place> findByCity(String city);

    List<Place> findByCityAndCategory(String city, ExpenseCategory category);

    List<Place> findByCategoryAndIsActiveTrue(ExpenseCategory category);

    Page<Place> findByIsActiveTrue(Pageable pageable);

    List<Place> findByCityOrderByRatingDescReviewCountDesc(String city);

    List<Place> findByIsIndoorTrueAndIsActiveTrue();
}