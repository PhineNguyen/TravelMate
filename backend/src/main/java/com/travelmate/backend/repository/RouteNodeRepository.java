package com.travelmate.backend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.RouteNode;

public interface RouteNodeRepository extends JpaRepository<RouteNode, Long> {

    List<RouteNode> findByRoutePlanId(Long routePlanId);

    List<RouteNode> findByRoutePlanIdOrderBySequenceOrderAsc(Long routePlanId);

    List<RouteNode> findByRoutePlanIdAndSequenceOrder(Long routePlanId, Integer sequenceOrder);

    List<RouteNode> findByPlaceId(Long placeId);

    boolean existsByRoutePlanIdAndSequenceOrder(Long routePlanId, Integer sequenceOrder);

}
