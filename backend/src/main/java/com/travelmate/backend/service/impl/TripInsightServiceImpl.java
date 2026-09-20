package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.response.BudgetSummaryResponse;
import com.travelmate.backend.dto.response.CategoryBreakdownResponse;
import com.travelmate.backend.dto.response.RuntimeSummaryResponse;
import com.travelmate.backend.entity.Expense;
import com.travelmate.backend.entity.ItineraryItem;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.repository.ExpenseRepository;
import com.travelmate.backend.repository.ItineraryItemRepository;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.service.TripInsightService;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class TripInsightServiceImpl implements TripInsightService {
        private final TripRepository tripRepository;
        private final ExpenseRepository expenseRepository;
        private final ItineraryItemRepository itineraryItemRepository;

        @Override
        @Transactional(readOnly = true)
        public BudgetSummaryResponse getBudgetSummary(Long tripId, Long userId) {
                Trip trip = getAccessibleTrip(tripId, userId);
                BigDecimal plannedBudget = Optional.ofNullable(trip.getTotalBudget()).orElse(BigDecimal.ZERO);
                BigDecimal spentBudget = expenseRepository.sumAmountByTripId(tripId);
                BigDecimal remainingBudget = plannedBudget.subtract(spentBudget);
                BigDecimal utilizationPercent = plannedBudget.signum() == 0
                                ? BigDecimal.ZERO
                                : spentBudget.multiply(BigDecimal.valueOf(100)).divide(plannedBudget, 2,
                                                RoundingMode.HALF_UP);
                String warningLevel = utilizationPercent.compareTo(BigDecimal.valueOf(90)) >= 0
                                ? "HIGH"
                                : utilizationPercent.compareTo(BigDecimal.valueOf(75)) >= 0 ? "MEDIUM" : "LOW";

                List<Expense> expenses = expenseRepository.findByTripIdAndIsDeletedFalse(tripId);

                List<CategoryBreakdownResponse> byCategory = expenses.stream()
                                .collect(Collectors.groupingBy(
                                                expense -> Optional.ofNullable(expense.getCategory()).orElse(com.travelmate.backend.entity.enums.ExpenseCategory.OTHER),
                                                LinkedHashMap::new,
                                                Collectors.reducing(BigDecimal.ZERO,
                                                                expense -> Optional.ofNullable(expense.getAmount())
                                                                                .orElse(BigDecimal.ZERO),
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
                                .expenseCount(expenses.size())
                                .byCategory(byCategory)
                                .build();
        }

        @Override
        @Transactional(readOnly = true)
        public RuntimeSummaryResponse getRuntimeSummary(Long tripId, Long userId) {
                Trip trip = getAccessibleTrip(tripId, userId);
                List<ItineraryItem> items = itineraryItemRepository
                                .findByTripIdOrderByDayNumberAscOrderIndexAsc(tripId);
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
                                                .map(item -> item.getPlace() != null ? item.getPlace().getName()
                                                                : item.getNote())
                                                .orElse(null));

                BigDecimal spentBudget = expenseRepository.sumAmountByTripId(tripId);
                BigDecimal plannedBudget = Optional.ofNullable(trip.getTotalBudget()).orElse(BigDecimal.ZERO);
                ItineraryItem nextItem = items.stream()
                                .filter(item -> !today.isBefore(trip.getStartDate()) && !today.isAfter(trip.getEndDate()))
                                .filter(item -> item.getDayNumber() == currentDay)
                                .filter(item -> item.getStartTime() == null || !item.getStartTime().isBefore(java.time.LocalTime.now()))
                                .sorted(java.util.Comparator.comparing(ItineraryItem::getStartTime,
                                        java.util.Comparator.nullsLast(java.util.Comparator.naturalOrder()))).findFirst().orElse(null);
                String mapsUrl = null;
                if (nextItem != null && nextItem.getPlace() != null) {
                        var place = nextItem.getPlace();
                        String destination = place.getLatitude() != null && place.getLongitude() != null
                                        ? place.getLatitude() + "," + place.getLongitude() : place.getName();
                        if (destination != null) mapsUrl = "https://www.google.com/maps/dir/?api=1&destination="
                                        + java.net.URLEncoder.encode(destination, java.nio.charset.StandardCharsets.UTF_8);
                }
                List<String> alerts = new ArrayList<>();
                if (plannedBudget.signum() > 0) {
                        BigDecimal overspend = spentBudget.subtract(plannedBudget);
                        if (overspend.signum() > 0) {
                                alerts.add("Budget exceeded by " + overspend);
                        }
                }

                return RuntimeSummaryResponse.builder()
                                .tripId(tripId)
                                .tripDate(trip.getStartDate())
                                .currentDay(currentDay)
                                .currentDestination(currentDestination)
                                .nextItemId(nextItem == null ? null : nextItem.getId())
                                .googleMapsUrl(mapsUrl)
                                .completedItems(completedItems)
                                .upcomingItems(upcomingItems)
                                .spentBudget(spentBudget)
                                .plannedBudget(plannedBudget)
                                .alerts(alerts)
                                .build();
        }

        private Trip getAccessibleTrip(Long tripId, Long userId) {
                Trip trip = tripRepository.findByIdAndIsDeletedFalse(tripId)
                                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));
                boolean ownsTrip = trip.getOwner() != null && userId.equals(trip.getOwner().getId());
                if (!ownsTrip) {
                        throw new org.springframework.security.access.AccessDeniedException("Access denied for this trip");
                }
                return trip;
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
}
