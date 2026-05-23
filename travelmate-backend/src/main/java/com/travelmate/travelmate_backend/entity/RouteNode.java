package com.travelmate.travelmate_backend.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.LocalTime;

@Entity
@Table(name = "route_node", indexes = {
                @Index(name = "idx_route_node_plan_sequence", columnList = "route_plan_id, sequence_order"),
                @Index(name = "idx_route_node_place", columnList = "place_id")
}, uniqueConstraints = {
                @UniqueConstraint(name = "uq_route_node_plan_sequence", columnNames = { "route_plan_id",
                                "sequence_order" })
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class RouteNode {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private Long id;

        // Mỗi node thuộc 1 route plan
        @ManyToOne(fetch = FetchType.LAZY, optional = false)
        @JoinColumn(name = "route_plan_id", nullable = false)
        private RoutePlan routePlan;

        // Node trỏ tới 1 place
        @ManyToOne(fetch = FetchType.LAZY)
        @JoinColumn(name = "place_id")
        private Place place;

        @Column(name = "sequence_order", nullable = false)
        private Integer sequenceOrder;

        @Column(name = "arrival_time")
        private LocalTime arrivalTime;

        @Column(name = "departure_time")
        private LocalTime departureTime;

        @Column(name = "travel_minutes")
        private Integer travelMinutes;
}