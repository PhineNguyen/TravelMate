package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.request.TripRequest;
import com.travelmate.backend.dto.request.TripUpdateRequest;
import com.travelmate.backend.dto.request.TripItineraryGenerateRequest;
import com.travelmate.backend.dto.response.TripResponse;
import com.travelmate.backend.dto.response.AiItineraryGenerateResponse;
import com.travelmate.backend.service.WeatherApiClientService;
import com.travelmate.backend.service.AiServiceClient;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.entity.ItineraryItem;
import com.travelmate.backend.entity.Place;
import com.travelmate.backend.entity.enums.ExpenseCategory;
import com.travelmate.backend.entity.enums.SourceType;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.repository.ItineraryItemRepository;
import com.travelmate.backend.repository.PlaceRepository;
import com.travelmate.backend.service.TripService;
import com.travelmate.backend.mapper.TripMapper;
import com.travelmate.backend.dto.ItineraryItemDTO;
import com.travelmate.backend.mapper.ItineraryItemMapper;
import com.travelmate.backend.entity.TripTemplate;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.entity.enums.TripStatus;

import com.travelmate.backend.repository.TripTemplateRepository;
import com.travelmate.backend.repository.UserRepository;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.Authentication;
import org.springframework.security.access.AccessDeniedException;

import lombok.RequiredArgsConstructor;
import java.math.RoundingMode;
import java.math.BigDecimal;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TripServiceImpl implements TripService {
    private final TripRepository tripRepository;
    private final UserRepository userRepository;
    private final TripTemplateRepository tripTemplateRepository;
    private final WeatherApiClientService weatherApiClientService;
    private final AiServiceClient aiServiceClient;
    private final ItineraryItemRepository itineraryItemRepository;
    private final PlaceRepository placeRepository;

    private void checkOwnership(Trip trip, User user) {
        if (!trip.getOwner().getId().equals(user.getId())) {
            throw new AccessDeniedException("Access denied. You are not the owner of this trip.");
        }
    }

    private void checkReadAccess(Trip trip, User user) {
        if (trip.getOwner().getId().equals(user.getId())) {
            return;
        }
        boolean isActiveCollaborator = trip.getTripParticipations().stream()
                .anyMatch(participant -> participant.isActive()
                        && participant.getUser().getId().equals(user.getId()));
        if (!isActiveCollaborator) {
            throw new AccessDeniedException("Access denied. You are not a collaborator on this trip.");
        }
    }

    private User getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (authentication == null
                || !authentication.isAuthenticated()
                || authentication.getPrincipal() == null) {
            throw new IllegalStateException("User not authenticated");
        }

        Object principal = authentication.getPrincipal();

        if (principal instanceof User user) {
            return user;
        }

        if (principal instanceof org.springframework.security.core.userdetails.UserDetails userDetails) {
            return userRepository.findByEmailAndActiveTrue(userDetails.getUsername())
                    .orElseThrow(() -> new IllegalStateException(
                            "Authenticated user not found in database"));
        }

        throw new IllegalStateException(
                "Unsupported authentication principal type: "
                        + principal.getClass().getName());
    }

    @Override
    @Transactional
    public TripResponse create(TripRequest dto) {
        if (dto == null) {
            throw new IllegalArgumentException("TripRequest must not be null");
        }

        if (dto.getId() != null) {
            throw new IllegalArgumentException("Id must be null when creating");
        }

        User owner = getCurrentUser();

        String destination = trimToNull(dto.getDestination());
        if (destination == null) {
            throw new IllegalArgumentException("Destination is required");
        }

        if (dto.getStartDate() == null) {
            throw new IllegalArgumentException("Start date is required");
        }
        if (dto.getEndDate() == null) {
            throw new IllegalArgumentException("End date is required");
        }
        if (dto.getEndDate().isBefore(dto.getStartDate())) {
            throw new IllegalArgumentException("End date must be greater than or equal to start date");
        }

        if (dto.getDuration() == null || dto.getDuration() <= 0) {
            throw new IllegalArgumentException(
                    "Duration must be greater than zero");
        }

        if (dto.getTravelerCount() == null || dto.getTravelerCount() <= 0) {
            throw new IllegalArgumentException(
                    "Traveler count must be greater than zero");
        }

        if (dto.getTotalBudget() != null
                && dto.getTotalBudget().signum() < 0) {
            throw new IllegalArgumentException("Budget must not be negative");
        }

        if (dto.getPlanningMode() == null) {
            throw new IllegalArgumentException("Planning mode is required");
        }

        TripTemplate tripTemplate = null;
        if (dto.getTemplateId() != null) {
            tripTemplate = tripTemplateRepository.findById(dto.getTemplateId())
                    .orElseThrow(() -> new IllegalArgumentException("Template not found"));
        }

        BigDecimal totalBudget = dto.getTotalBudget() != null
                ? dto.getTotalBudget().setScale(2, RoundingMode.HALF_UP)
                : null;

        String inviteCode = trimToNull(dto.getInviteCode());
        if (inviteCode == null) {
            inviteCode = generateUniqueInviteCode();
        } else {
            if (tripRepository.existsByInviteCodeAndIsDeletedFalse(inviteCode)) {
                throw new IllegalArgumentException("Invite code already in use");
            }
        }

        TripStatus status = dto.getTripStatus() != null ? dto.getTripStatus() : TripStatus.DRAFT;
        validateCreateStatus(status);
        boolean isCustomized = dto.getIsCustomized() != null ? dto.getIsCustomized() : false;

        Trip trip = Trip.builder()
                .owner(owner)
                .destination(trimToNull(dto.getDestination()))
                .startDate(dto.getStartDate())
                .endDate(dto.getEndDate())
                .duration(dto.getDuration())
                .travelerCount(dto.getTravelerCount()) // ✅ Map trường mới vào Entity
                .totalBudget(totalBudget)
                .planningMode(dto.getPlanningMode())
                .template(tripTemplate)
                .isCustomized(isCustomized)
                .tripStatus(status)
                .inviteCode(inviteCode)
                .isDeleted(false)
                .build();
        try {
            Trip savedTrip = tripRepository.save(trip);
            // Fetch weather data if trip is created as active
            if (savedTrip.getTripStatus() == TripStatus.ACTIVE) {
                weatherApiClientService.fetchAndProcessWeatherData(savedTrip.getDestination(), savedTrip);
            }
            return TripMapper.toResponse(savedTrip);
        } catch (DataIntegrityViolationException ex) {
            throw new DataIntegrityViolationException("Database constraint violated, check for unique invite code.",
                    ex);
        }
    }

    @Override
    @Transactional
    public TripResponse update(TripUpdateRequest dto) {
        if (dto == null) {
            throw new IllegalArgumentException("TripRequest must be not null");
        }
        if (dto.getId() == null) {
            throw new IllegalArgumentException("Id is required to update");
        }
        Trip existing = tripRepository.findByIdAndIsDeletedFalse(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("TripId not found or has been deleted"));

        User currentUser = getCurrentUser();
        checkOwnership(existing, currentUser);

        TripStatus previousStatus = existing.getTripStatus();

        if (isTerminal(existing.getTripStatus())) {
            throw new IllegalArgumentException("Trip is read-only in terminal state");
        }
        if (dto.getDestination() != null)
            existing.setDestination(trimToNull(dto.getDestination()));
        if (dto.getStartDate() != null)
            existing.setStartDate(dto.getStartDate());
        if (dto.getEndDate() != null)
            existing.setEndDate(dto.getEndDate());
        if (existing.getEndDate() == null || existing.getEndDate().isBefore(existing.getStartDate()))
            throw new IllegalArgumentException("End date must be greater than or equal to start date");
        if (dto.getDuration() != null) {
            if (dto.getDuration() <= 0)
                throw new IllegalArgumentException("Duration must not be <= 0");
            existing.setDuration(dto.getDuration());
        }
        // Xử lý thay đổi số lượng người tham gia
        if (dto.getTravelerCount() != null) {
            if (dto.getTravelerCount() <= 0)
                throw new IllegalArgumentException("Traveler count must not be <= 0");
            existing.setTravelerCount(dto.getTravelerCount());
        }
        if (dto.getTotalBudget() != null) {
            if (dto.getTotalBudget().signum() < 0)
                throw new IllegalArgumentException("Budget must not be negative");
            existing.setTotalBudget(dto.getTotalBudget().setScale(2, RoundingMode.HALF_UP));
        }
        if (dto.getPlanningMode() != null)
            existing.setPlanningMode(dto.getPlanningMode());
        if (dto.getIsCustomized() != null)
            existing.setCustomized(dto.getIsCustomized());
        if (dto.getTripStatus() != null)
            validateAndSetStatus(existing, dto.getTripStatus());

        if (dto.getTemplateId() != null) {
            TripTemplate tripTemplate = tripTemplateRepository.findById(dto.getTemplateId())
                    .orElseThrow(() -> new IllegalArgumentException("TemplateID not found"));
            existing.setTemplate(tripTemplate);
        }
        try {
            Trip updatedTrip = tripRepository.save(existing);

            // If trip status changed to ACTIVE, fetch weather data
            if (previousStatus != TripStatus.ACTIVE && updatedTrip.getTripStatus() == TripStatus.ACTIVE) {
                weatherApiClientService.fetchAndProcessWeatherData(updatedTrip.getDestination(), updatedTrip);
            }

            return TripMapper.toResponse(updatedTrip);
        } catch (DataIntegrityViolationException ex) {
            throw new DataIntegrityViolationException("Database constraint violated on update.", ex);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public TripResponse findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("Id must not be null");

        Trip trip = tripRepository.findByIdAndIsDeletedFalse(id)
                .orElseThrow(() -> new IllegalArgumentException("Trip not found or deleted"));

        // Lấy user hiện tại và kiểm tra quyền XEM
        User currentUser = getCurrentUser(); // Nhớ dùng hàm getCurrentUser ép kiểu UserDetails của bạn
        checkReadAccess(trip, currentUser);

        return TripMapper.toResponse(trip);
    }

    @Override
    @Transactional(readOnly = true)
    public List<TripResponse> listAll() {
        return tripRepository.findAllByIsDeletedFalse().stream()
                .map(TripMapper::toResponse)
                .collect(Collectors.toList());
    }

    /**
     * ✅ HOÀN THIỆN: Tìm kiếm, lọc động và phân trang danh sách chuyến đi (Chưa xóa)
     */
    @Override
    @Transactional(readOnly = true)
    public Page<TripResponse> searchTrips(Long ownerId, TripStatus status, String destination, Pageable pageable) {
        String cleanDestination = trimToNull(destination);

        if (ownerId != null && status != null) {
            // Trường hợp có cả Owner và Status (Dùng câu Query sẵn của Repository)
            return tripRepository.findByOwnerIdAndTripStatusAndIsDeletedFalse(ownerId, status, pageable)
                    .map(TripMapper::toResponse);
        } else if (ownerId != null) {
            return tripRepository.findByOwnerIdAndIsDeletedFalse(ownerId, pageable)
                    .map(TripMapper::toResponse);
        } else if (status != null) {
            return tripRepository.findByTripStatusAndIsDeletedFalse(status, pageable)
                    .map(TripMapper::toResponse);
        } else if (cleanDestination != null) {
            return tripRepository.findByDestinationIgnoreCaseAndIsDeletedFalse(cleanDestination, pageable)
                    .map(TripMapper::toResponse);
        }

        // Mặc định trả về toàn bộ dữ liệu chưa xóa có phân trang
        return tripRepository.findAllByIsDeletedFalse(pageable)
                .map(TripMapper::toResponse);
    }

    @Override
    @Transactional(readOnly = true)
    public Page<TripResponse> getMyTrips(String view, Pageable pageable) {
        User currentUser = getCurrentUser();
        String selectedView = view == null ? "owned" : view.trim().toLowerCase();

        Page<Trip> trips = switch (selectedView) {
            case "owned" -> tripRepository.findByOwnerIdAndIsDeletedFalse(currentUser.getId(), pageable);
            case "joined" -> tripRepository.findJoinedTrips(currentUser.getId(), pageable);
            case "completed" -> tripRepository.findAccessibleTripsByStatus(
                    currentUser.getId(), TripStatus.COMPLETED, pageable);
            default -> throw new IllegalArgumentException("View must be owned, joined, or completed");
        };
        return trips.map(TripMapper::toResponse);
    }

    /**
     * ✅ THAY ĐỔI: Thực hiện logic Xóa Mềm thay vì xóa vật lý dữ liệu
     */
    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id is required");
        }

        Trip trip = tripRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));

        User currentUser = getCurrentUser();
        checkOwnership(trip, currentUser);

        int rowsAffected = tripRepository.softDeleteById(id);
        if (rowsAffected == 0) {
            throw new IllegalArgumentException("Trip not found or already deleted");
        }
    }

    /**
     * ✅ HOÀN THIỆN: Khôi phục một chuyến đi đã bị xóa mềm trước đó
     */
    @Override
    @Transactional
    public TripResponse restore(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("Id is required to restore");
        }

        // Tìm kiếm bản ghi gốc (Bao gồm cả bản ghi đã bị xóa) thông qua hàm findById
        // mặc định của JPA
        Trip trip = tripRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Trip not found"));

        User currentUser = getCurrentUser();
        checkOwnership(trip, currentUser);

        if (!trip.isDeleted()) {
            throw new IllegalArgumentException("Trip is already active and does not need restoration");
        }

        // Đảo ngược trạng thái xóa mềm
        trip.setDeleted(false);
        trip.setDeletedAt(null);

        return TripMapper.toResponse(tripRepository.save(trip));
    }

    private String generateUniqueInviteCode() {
        String code;
        do {
            code = UUID.randomUUID().toString().replace("-", "").substring(0, 10).toUpperCase();
        } while (tripRepository.existsByInviteCodeAndIsDeletedFalse(code));
        return code;
    }

    private String trimToNull(String v) {
        if (v == null)
            return null;
        String t = v.trim();
        return t.isEmpty() ? null : t;
    }

    private void validateCreateStatus(TripStatus status) {
        if (status == TripStatus.ARCHIVED) {
            throw new IllegalArgumentException("ARCHIVED is not allowed for new trip");
        }
    }

    private void validateAndSetStatus(Trip existing, TripStatus requestedStatus) {
        TripStatus current = existing.getTripStatus();
        if (requestedStatus == current) {
            return;
        }
        if (!isAllowedTransition(current, requestedStatus)) {
            throw new IllegalArgumentException("Invalid trip status transition");
        }
        existing.setTripStatus(requestedStatus);
    }

    private boolean isAllowedTransition(TripStatus current, TripStatus next) {
        return switch (current) {
            case DRAFT -> next == TripStatus.PLANNED || next == TripStatus.CANCELLED;
            case PLANNED -> next == TripStatus.DRAFT || next == TripStatus.ACTIVE || next == TripStatus.CANCELLED;
            case ACTIVE -> next == TripStatus.COMPLETED || next == TripStatus.CANCELLED;
            case COMPLETED, CANCELLED, ARCHIVED -> false;
        };
    }

    private boolean isTerminal(TripStatus status) {
        return status == TripStatus.COMPLETED || status == TripStatus.CANCELLED || status == TripStatus.ARCHIVED;
    }

    @Override
    @Transactional
    public List<ItineraryItemDTO> generateItineraryWithAI(Long id, TripItineraryGenerateRequest request) {
        if (id == null) {
            throw new IllegalArgumentException("Trip ID is required");
        }
        if (request == null) {
            throw new IllegalArgumentException("Request body is required");
        }

        // 1. Tìm Trip và kiểm tra quyền sở hữu
        Trip trip = tripRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Trip not found with id: " + id));
        User currentUser = getCurrentUser();
        checkOwnership(trip, currentUser);

        // 2. Chuyển đổi thông tin sang Request AI
        Double budget = trip.getTotalBudget() != null ? trip.getTotalBudget().doubleValue() : 0.0;
        Integer duration = trip.getDuration() != null ? trip.getDuration() : 1;
        Integer travelerCount = trip.getTravelerCount() != null ? trip.getTravelerCount() : 1;

        // 3. Gọi AI Service
        AiItineraryGenerateResponse response = aiServiceClient.generateItinerary(
                trip.getDestination(),
                duration,
                budget,
                request.getTravelStyle(),
                travelerCount,
                request.getPreferences());

        // 4. Xóa sạch lịch trình cũ nếu có
        List<ItineraryItem> oldItems = itineraryItemRepository.findByTripId(id);
        itineraryItemRepository.deleteAll(oldItems);

        // 5. Duyệt và lưu lịch trình mới từ AI
        List<ItineraryItem> savedItems = new java.util.ArrayList<>();
        if (response != null && response.getItinerary() != null) {
            for (AiItineraryGenerateResponse.DayItinerary day : response.getItinerary()) {
                int orderIndex = 1;
                if (day.getActivities() != null) {
                    for (AiItineraryGenerateResponse.AiActivity act : day.getActivities()) {
                        // Tìm hoặc tạo mới Place
                        Place place = findOrCreatePlace(act.getPlace_name(), act.getDescription(),
                                trip.getDestination(), act.getCategory());

                        // Parse Start Time
                        LocalTime startTime = LocalTime.of(8, 0); // Default fallback
                        if (act.getStart_time() != null && act.getStart_time().contains(":")) {
                            try {
                                String[] parts = act.getStart_time().trim().split(":");
                                int hr = Integer.parseInt(parts[0]);
                                int min = Integer.parseInt(parts[1]);
                                startTime = LocalTime.of(hr, min);
                            } catch (Exception e) {
                                // Keep default fallback
                            }
                        }

                        // Create ItineraryItem
                        ItineraryItem item = ItineraryItem.builder()
                                .trip(trip)
                                .place(place)
                                .dayNumber(day.getDay() != null ? day.getDay() : 1)
                                .startTime(startTime)
                                .duration(act.getDuration_minutes() != null ? act.getDuration_minutes() : 60)
                                .note(act.getDescription())
                                .costEstimate(
                                        act.getEstimated_cost() != null ? BigDecimal.valueOf(act.getEstimated_cost())
                                                : BigDecimal.ZERO)
                                .orderIndex(orderIndex++)
                                .sourceType(SourceType.AI)
                                .isLocked(false)
                                .build();

                        savedItems.add(itineraryItemRepository.save(item));
                    }
                }
            }
        }
        return savedItems.stream()
                .map(ItineraryItemMapper::toDto)
                .collect(Collectors.toList());
    }

    private Place findOrCreatePlace(String name, String description, String city, String aiCategory) {
        if (name == null || name.trim().isEmpty()) {
            return null;
        }

        Optional<Place> existing = placeRepository.findByNameAndCityAndCountry(name.trim(), city, "Vietnam");
        if (existing.isPresent()) {
            return existing.get();
        }

        // Map Category
        ExpenseCategory category = ExpenseCategory.OTHER;
        if (aiCategory != null) {
            String cat = aiCategory.toLowerCase().trim();
            if (cat.equals("restaurant") || cat.contains("food")) {
                category = ExpenseCategory.FOOD;
            } else if (cat.equals("accommodation") || cat.contains("hotel")) {
                category = ExpenseCategory.HOTEL;
            } else if (cat.equals("attraction") || cat.contains("sight") || cat.contains("entertainment")) {
                category = ExpenseCategory.ENTERTAINMENT;
            }
        }

        Place newPlace = Place.builder()
                .name(name.trim())
                .description(description)
                .city(city)
                .country("Vietnam")
                .category(category)
                .isActive(true)
                .build();

        return placeRepository.save(newPlace);
    }
}