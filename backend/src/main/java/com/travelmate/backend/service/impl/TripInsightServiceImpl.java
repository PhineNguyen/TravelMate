package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.response.BudgetSummaryResponse;
import com.travelmate.backend.dto.response.CategoryBreakdownResponse;
import com.travelmate.backend.dto.response.DashboardOverviewResponse;
import com.travelmate.backend.dto.response.RouteStopResponse;
import com.travelmate.backend.dto.response.RouteSummaryResponse;
import com.travelmate.backend.dto.response.RuntimeSummaryResponse;
import com.travelmate.backend.dto.response.TripMiniResponse;
import com.travelmate.backend.entity.ItineraryItem;
import com.travelmate.backend.entity.RouteNode;
import com.travelmate.backend.entity.RoutePlan;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.TripParticipant;
import com.travelmate.backend.entity.WeatherAlert;
import com.travelmate.backend.entity.enums.AlertSeverity;
import com.travelmate.backend.entity.enums.TripStatus;
import com.travelmate.backend.repository.ExpenseRepository;
import com.travelmate.backend.repository.ItineraryItemRepository;
import com.travelmate.backend.repository.NotificationRepository;
import com.travelmate.backend.repository.RouteNodeRepository;
import com.travelmate.backend.repository.RoutePlanRepository;
import com.travelmate.backend.repository.TripParticipantRepository;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.repository.WeatherAlertRepository;
import com.travelmate.backend.service.TripInsightService;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class TripInsightServiceImpl implements TripInsightService {
    private final TripRepository tripRepository;
    private final TripParticipantRepository tripParticipantRepository;
    private final ExpenseRepository expenseRepository;
    private final RoutePlanRepository routePlanRepository;
    private final RouteNodeRepository routeNodeRepository;
    private final ItineraryItemRepository itineraryItemRepository;
    private final WeatherAlertRepository weatherAlertRepository;
    private final NotificationRepository notificationRepository;

    @Override
    @Transactional(readOnly = true)
    public DashboardOverviewResponse getDashboard(Long userId) {
        List<Trip> accessibleTrips = getAccessibleTrips(userId);
        long totalTrips = accessibleTrips.size();
        long activeTrips = accessibleTrips.stream().filter(trip -> trip.getTripStatus() == TripStatus.ACTIVE).count();
        long joinedTrips = tripParticipantRepository.findByUserIdAndIsActiveTrue(userId).stream()
                .map(TripParticipant::getTrip)
                .filter(this::isNotDeleted)
                .map(Trip::getId)
                .distinct()
                .count();

        BigDecimal totalSpent = accessibleTrips.stream()
                .map(trip -> expenseRepository.sumAmountByTripId(trip.getId()))
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        List<Trip> budgetedTrips = accessibleTrips.stream()
                .filter(trip -> trip.getTotalBudget() != null)
                .toList();
        BigDecimal averageBudget = budgetedTrips.isEmpty()
                ? BigDecimal.ZERO
                : budgetedTrips.stream().map(Trip::getTotalBudget).reduce(BigDecimal.ZERO, BigDecimal::add)
                        .divide(BigDecimal.valueOf(budgetedTrips.size()), 2, RoundingMode.HALF_UP);

        long unreadNotifications = notificationRepository.countByUserIdAndIsReadFalse(userId);
        List<TripMiniResponse> recentTrips = accessibleTrips.stream()
                .sorted(Comparator.comparing(Trip::getUpdatedAt, Comparator.nullsLast(Comparator.naturalOrder()))
                        .reversed())
                .limit(5)
                .map(this::toTripMiniResponse)
                .collect(Collectors.toList());

        return DashboardOverviewResponse.builder()
                .userId(userId)
                .totalTrips(totalTrips)
                .activeTrips(activeTrips)
                .joinedTrips(joinedTrips)
                .totalSpent(totalSpent)
                .averageBudget(averageBudget)
                .unreadNotifications(unreadNotifications)
                .recentTrips(recentTrips)
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public BudgetSummaryResponse getBudgetSummary(Long tripId, Long userId) {
        Trip trip = getAccessibleTrip(tripId, userId);
        BigDecimal plannedBudget = Optional.ofNullable(trip.getTotalBudget()).orElse(BigDecimal.ZERO);
        BigDecimal spentBudget = expenseRepository.sumAmountByTripId(tripId);
        BigDecimal remainingBudget = plannedBudget.subtract(spentBudget);
        BigDecimal utilizationPercent = plannedBudget.signum() == 0
                ? BigDecimal.ZERO
                : spentBudget.multiply(BigDecimal.valueOf(100)).divide(plannedBudget, 2, RoundingMode.HALF_UP);
        String warningLevel = utilizationPercent.compareTo(BigDecimal.valueOf(90)) >= 0
                ? "HIGH"
                : utilizationPercent.compareTo(BigDecimal.valueOf(75)) >= 0 ? "MEDIUM" : "LOW";

        List<CategoryBreakdownResponse> byCategory = expenseRepository.findByTripId(tripId).stream()
                .collect(Collectors.groupingBy(
                        expense -> Optional.ofNullable(expense.getCategory()).orElse(null),
                        LinkedHashMap::new,
                        Collectors.reducing(BigDecimal.ZERO,
                                expense -> Optional.ofNullable(expense.getAmount()).orElse(BigDecimal.ZERO),
                                BigDecimal::add)))
                .entrySet().stream()
                .filter(entry -> entry.getKey() != null)
                .map(entry -> CategoryBreakdownResponse.builder()
                        .category(entry.getKey())
                        .amount(entry.getValue())
                        .build())
                .collect(Collectors.toList());

        return BudgetSummaryResponse.builder()
                .tripId(tripId)
                .plannedBudget(plannedBudget)
                .spentBudget(spentBudget)
                .remainingBudget(remainingBudget)
                .utilizationPercent(utilizationPercent)
                .warningLevel(warningLevel)
                .expenseCount(expenseRepository.findByTripId(tripId).size())
                .byCategory(byCategory)
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public RouteSummaryResponse getRouteSummary(Long tripId, Long userId) {
        getAccessibleTrip(tripId, userId);
        RoutePlan routePlan = routePlanRepository.findTopByTripIdOrderByOptimizedAtDesc(tripId).orElse(null);
        if (routePlan == null) {
            return RouteSummaryResponse.builder()
                    .tripId(tripId)
                    .stops(List.of())
                    .build();
        }

        List<RouteNode> nodes = routeNodeRepository.findByRoutePlanIdOrderBySequenceOrderAsc(routePlan.getId());
        List<RouteStopResponse> stops = nodes.stream().map(node -> RouteStopResponse.builder()
                .sequenceOrder(node.getSequenceOrder())
                .placeName(node.getPlace() != null ? node.getPlace().getName() : null)
                .arrivalTime(node.getArrivalTime())
                .departureTime(node.getDepartureTime())
                .build()).collect(Collectors.toList());

        String nextStop = stops.isEmpty() ? null : stops.get(0).getPlaceName();
        return RouteSummaryResponse.builder()
                .tripId(tripId)
                .strategyType(routePlan.getStrategyType())
                .totalDistanceKm(routePlan.getTotalDistance() != null ? BigDecimal.valueOf(routePlan.getTotalDistance())
                        : BigDecimal.ZERO)
                .estimatedDurationMinutes(routePlan.getEstimatedDuration())
                .nextStop(nextStop)
                .stops(stops)
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public RuntimeSummaryResponse getRuntimeSummary(Long tripId, Long userId) {
        Trip trip = getAccessibleTrip(tripId, userId);
        List<ItineraryItem> items = itineraryItemRepository.findByTripIdOrderByDayNumberAscOrderIndexAsc(tripId);
        LocalDate today = LocalDate.now();
        int currentDay = calculateCurrentDay(trip, today);
        long completedItems = items.stream().filter(item -> item.getDayNumber() < currentDay).count();
        long upcomingItems = items.stream().filter(item -> item.getDayNumber() >= currentDay).count();

        String currentDestination = items.stream()
                .filter(item -> item.getDayNumber() == currentDay)
                .findFirst()
                .map(item -> item.getPlace() != null ? item.getPlace().getName() : item.getNote())
                .orElseGet(() -> items.stream()
                        .findFirst()
                        .map(item -> item.getPlace() != null ? item.getPlace().getName() : item.getNote())
                        .orElse(null));

        BigDecimal spentBudget = expenseRepository.sumAmountByTripId(tripId);
        BigDecimal plannedBudget = Optional.ofNullable(trip.getTotalBudget()).orElse(BigDecimal.ZERO);
        List<String> alerts = new ArrayList<>();
        weatherAlertRepository.findTopByTripIdOrderByCreatedAtDesc(tripId)
                .ifPresent(alert -> alerts.add(formatAlert(alert)));
        if (weatherAlertRepository.countByTripIdAndIsResolvedFalse(tripId) > 0) {
            alerts.add("There are unresolved weather alerts for this trip");
        }
        if (plannedBudget.signum() > 0) {
            BigDecimal overspend = spentBudget.subtract(plannedBudget);
            if (overspend.signum() > 0) {
                alerts.add("Budget exceeded by " + overspend);
            }
        }

        long activeParticipants = tripParticipantRepository.countByTripIdAndIsActiveTrue(tripId);
        return RuntimeSummaryResponse.builder()
                .tripId(tripId)
                .tripDate(trip.getStartDate())
                .currentDay(currentDay)
                .currentDestination(currentDestination)
                .completedItems(completedItems)
                .upcomingItems(upcomingItems)
                .activeParticipants(activeParticipants)
                .unreadNotifications(notificationRepository.countByUserIdAndIsReadFalse(userId))
                .spentBudget(spentBudget)
                .plannedBudget(plannedBudget)
                .alerts(alerts)
                .build();
    }

    private List<Trip> getAccessibleTrips(Long userId) {
        Map<Long, Trip> trips = new LinkedHashMap<>();
        tripRepository.findByOwnerIdAndIsDeletedFalse(userId).forEach(trip -> trips.put(trip.getId(), trip));
        tripParticipantRepository.findByUserIdAndIsActiveTrue(userId).stream()
                .map(TripParticipant::getTrip)
                .filter(this::isNotDeleted)
                .forEach(trip -> trips.putIfAbsent(trip.getId(), trip));
        return trips.values().stream()
                .sorted(Comparator.comparing(Trip::getCreatedAt, Comparator.nullsLast(Comparator.naturalOrder()))
                        .reversed())
                .collect(Collectors.toList());
    }

    private Trip getAccessibleTrip(Long tripId, Long userId) {
        Trip trip = tripRepository.findByIdAndIsDeletedFalse(tripId)
                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));
        boolean ownsTrip = trip.getOwner() != null && userId.equals(trip.getOwner().getId());
        boolean joinedTrip = tripParticipantRepository.existsByTripIdAndUserId(tripId, userId);
        if (!ownsTrip && !joinedTrip) {
            throw new IllegalArgumentException("Access denied for this trip");
        }
        return trip;
    }

    private boolean isNotDeleted(Trip trip) {
        return trip != null && !trip.isDeleted();
    }

    private TripMiniResponse toTripMiniResponse(Trip trip) {
        return TripMiniResponse.builder()
                .id(trip.getId())
                .destination(trip.getDestination())
                .startDate(trip.getStartDate())
                .tripStatus(trip.getTripStatus())
                .build();
    }

    private int calculateCurrentDay(Trip trip, LocalDate today) {
        if (trip.getStartDate() == null) {
            return 1;
        }
        long daysSinceStart = ChronoUnit.DAYS.between(trip.getStartDate(), today);
        int currentDay = (int) daysSinceStart + 1;
        if (currentDay < 1) {
            return 1;
        }
        if (trip.getDuration() != null) {
            return Math.min(currentDay, trip.getDuration());
        }
        return currentDay;
    }

    private String formatAlert(WeatherAlert alert) {
        String severity = alert.getSeverity() != null ? alert.getSeverity().name() : AlertSeverity.MEDIUM.name();
        String type = alert.getAlertType() != null ? alert.getAlertType().name() : "WEATHER";
        String action = alert.getSuggestedAction() != null ? alert.getSuggestedAction() : "Review itinerary conditions";
        return severity + " " + type + ": " + action;
    }
}
