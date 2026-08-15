package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.request.TripRequest;
import com.travelmate.backend.dto.response.TripResponse;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.entity.enums.Role;
import com.travelmate.backend.entity.enums.TripStatus;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.service.WeatherApiClientService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.*;

@SpringBootTest
@Transactional
class TripServiceImplTest {

    @Autowired
    private TripServiceImpl tripService;

    @Autowired
    private TripRepository tripRepository;

    @Autowired
    private UserRepository userRepository;

    @MockBean // Sử dụng @MockBean để giả lập service gọi API ngoài
    private WeatherApiClientService weatherApiClientService;

    private User testUser;
    private Trip testTrip;

    @BeforeEach
    void setUp() {
        // Tạo người dùng mẫu
        User user = new User();
        user.setFullName("Test User");
        user.setEmail("tripservicetest@example.com");
        user.setPassword("password123");
        user.setRole(Role.USER);
        testUser = userRepository.save(user);

        // Tạo chuyến đi mẫu ở trạng thái DRAFT
        Trip trip = new Trip();
        trip.setOwner(testUser);
        trip.setTitle("Trip to Test Weather");
        trip.setDestination("Hanoi");
        trip.setStartDate(LocalDate.now().plusDays(5));
        trip.setDuration(7);
        trip.setTripStatus(TripStatus.DRAFT); // Bắt đầu ở trạng thái nháp
        trip.setTotalBudget(new BigDecimal("2000.00"));
        testTrip = tripRepository.save(trip);
    }

    @Test
    void whenTripStatusIsUpdatedToActive_thenFetchAndProcessWeatherDataIsCalled() {
        // Arrange: Chuẩn bị dữ liệu để cập nhật chuyến đi
        TripRequest updateRequest = new TripRequest();
        updateRequest.setId(testTrip.getId());
        updateRequest.setTripStatus(TripStatus.ACTIVE); // Chuyển trạng thái sang ACTIVE

        // Giả lập hành vi của weatherApiClientService
        // Chúng ta không quan tâm nó làm gì, chỉ cần biết nó được gọi
        doNothing().when(weatherApiClientService).fetchAndProcessWeatherData(anyString(), any(Trip.class));

        // Act: Thực hiện hành động cập nhật chuyến đi
        TripResponse updatedTripResponse = tripService.update(updateRequest);

        // Assert: Kiểm tra kết quả
        // 1. Đảm bảo chuyến đi đã được cập nhật thành công
        assertThat(updatedTripResponse).isNotNull();
        assertThat(updatedTripResponse.getTripStatus()).isEqualTo(TripStatus.ACTIVE);

        // 2. KIỂM TRA QUAN TRỌNG NHẤT:
        // Xác minh rằng phương thức fetchAndProcessWeatherData đã được gọi ĐÚNG 1 LẦN
        // với các tham số là "Hanoi" và đối tượng Trip tương ứng.
        verify(weatherApiClientService, times(1)).fetchAndProcessWeatherData(eq("Hanoi"), any(Trip.class));

        // Đảm bảo không có tương tác nào khác với mock này
        verifyNoMoreInteractions(weatherApiClientService);
    }
}