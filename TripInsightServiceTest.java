package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.response.RuntimeSummaryResponse;
import com.travelmate.backend.entity.Expense;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.entity.WeatherAlert;
import com.travelmate.backend.entity.enums.AlertSeverity;
import com.travelmate.backend.entity.enums.AlertType;
import com.travelmate.backend.entity.enums.Role;
import com.travelmate.backend.entity.enums.TripStatus;
import com.travelmate.backend.repository.ExpenseRepository;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.repository.WeatherAlertRepository;
import com.travelmate.backend.service.TripInsightService;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
@Transactional // Rolls back transactions after each test
class TripInsightServiceTest {

        @Autowired
        private TripInsightService tripInsightService;

        @Autowired
        private TripRepository tripRepository;

        @Autowired
        private ExpenseRepository expenseRepository;

        @Autowired
        private UserRepository userRepository;

        @Autowired
        private WeatherAlertRepository weatherAlertRepository;

        private User testUser;
        private Trip testTrip;

        @BeforeEach
        void setUp() {
                User user = new User();
                user.setFullName("Test User");
                user.setEmail("testuser@example.com");
                user.setPassword("password123");
                user.setRole(Role.USER);
                testUser = userRepository.save(user);

                Trip trip = new Trip();
                trip.setOwner(testUser);
                trip.setTitle("Test Trip");
                trip.setDestination("Test Destination");
                trip.setStartDate(LocalDate.now().minusDays(2));
                trip.setDuration(5);
                trip.setTripStatus(TripStatus.ACTIVE);
                trip.setTotalBudget(new BigDecimal("1000.00"));
                trip.setDeleted(false);
                testTrip = tripRepository.save(trip);
        }

        @Test
        void getRuntimeSummary_whenBudgetExceeded_shouldReturnOverspendAlert() {
                // Arrange
                testTrip.setTotalBudget(new BigDecimal("1000.00"));
                tripRepository.save(testTrip);

                expenseRepository.save(Expense.builder()
                                .trip(testTrip)
                                .amount(new BigDecimal("700.00"))
                                .description("Flight")
                                .build());

                expenseRepository.save(Expense.builder()
                                .trip(testTrip)
                                .amount(new BigDecimal("500.00"))
                                .description("Hotel")
                                .build());

                // Act
                RuntimeSummaryResponse summary = tripInsightService.getRuntimeSummary(testTrip.getId(),
                                testUser.getId());

                // Assert
                assertThat(summary).isNotNull();
                assertThat(summary.getPlannedBudget()).isEqualByComparingTo("1000.00");
                assertThat(summary.getSpentBudget()).isEqualByComparingTo("1200.00");
                assertThat(summary.getAlerts())
                                .isNotNull()
                                .contains("Budget exceeded by 200.00");
        }

        @Test
        void getRuntimeSummary_whenBudgetNotExceeded_shouldNotReturnOverspendAlert() {
                // Arrange
                testTrip.setTotalBudget(new BigDecimal("1500.00"));
                tripRepository.save(testTrip);

                expenseRepository.save(Expense.builder()
                                .trip(testTrip)
                                .amount(new BigDecimal("1200.00"))
                                .description("Stuff")
                                .build());

                // Act
                RuntimeSummaryResponse summary = tripInsightService.getRuntimeSummary(testTrip.getId(),
                                testUser.getId());

                // Assert
                assertThat(summary).isNotNull();
                assertThat(summary.getPlannedBudget()).isEqualByComparingTo("1500.00");
                assertThat(summary.getSpentBudget()).isEqualByComparingTo("1200.00");
                assertThat(summary.getAlerts()).isEmpty();
        }

        @Test
        void getRuntimeSummary_whenBudgetExceededAndWeatherAlertExists_shouldReturnMultipleAlerts() {
                // Arrange
                testTrip.setTotalBudget(new BigDecimal("500.00"));
                tripRepository.save(testTrip);

                expenseRepository.save(Expense.builder()
                                .trip(testTrip)
                                .amount(new BigDecimal("600.00"))
                                .description("Expensive Meal")
                                .build());

                WeatherAlert weatherAlert = WeatherAlert.builder()
                                .trip(testTrip)
                                .alertType(AlertType.RAIN_EXPECTED)
                                .severity(AlertSeverity.HIGH)
                                .description("High probability of rain (80%).")
                                .suggestedAction("Take an umbrella.")
                                .isResolved(false)
                                .build();
                weatherAlertRepository.save(weatherAlert);

                // Act
                RuntimeSummaryResponse summary = tripInsightService.getRuntimeSummary(testTrip.getId(),
                                testUser.getId());

                // Assert
                assertThat(summary).isNotNull();
                assertThat(summary.getSpentBudget()).isEqualByComparingTo("600.00");
                assertThat(summary.getAlerts()).contains(
                                "HIGH RAIN_EXPECTED: Take an umbrella.",
                                "Budget exceeded by 100.00");
        }
}