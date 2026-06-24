package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.request.TripRequest;
import com.travelmate.backend.dto.response.TripResponse;
import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.service.TripService;
import com.travelmate.backend.mapper.TripMapper;

import com.travelmate.backend.entity.TripTemplate;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.entity.enums.PlanningMode;
import com.travelmate.backend.entity.enums.TripStatus;

import com.travelmate.backend.repository.TripTemplateRepository;
import com.travelmate.backend.repository.UserRepository;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class TripServiceImpl implements TripService {
    private final TripRepository tripRepository;
    private final UserRepository userRepository;
    private final TripTemplateRepository tripTemplateRepository;

    @Override
    @Transactional
    public TripResponse create(TripRequest dto) {
        if (dto == null) {
            throw new IllegalArgumentException("TripRequest must not be null");
        }
        if (dto.getId() != null) {
            throw new IllegalArgumentException("Id must be null when creating");
        }
        if (dto.getOwnerId() == null) {
            throw new IllegalArgumentException("OwnerId is required");
        }
        if (trimToNull(dto.getDestination()) == null) {
            throw new IllegalArgumentException("Destination is required");
        }
        if (dto.getStartDate() == null) {
            throw new IllegalArgumentException("StartDate is required");
        }
        if (dto.getDuration() == null || dto.getDuration() <= 0) {
            throw new IllegalArgumentException("Duration must be > 0");
        }
        // ✅ KIỂM TRA RÀNG BUỘC NGHIỆP VỤ: Số lượng người đi phải lớn hơn 0
        if (dto.getTravelerCount() == null || dto.getTravelerCount() <= 0) {
            throw new IllegalArgumentException("Traveler count must be > 0");
        }
        if (dto.getPlanningMode() == null) {
            throw new IllegalArgumentException("PlanningMode is required");
        }

        User owner = userRepository.findById(dto.getOwnerId())
                .orElseThrow(() -> new IllegalArgumentException("OwnerId not found"));

        TripTemplate tripTemplate = null;
        if (dto.getTemplateId() != null) {
            tripTemplate = tripTemplateRepository.findById(dto.getTemplateId())
                    .orElseThrow(() -> new IllegalArgumentException("Template not found"));
        }

        java.math.BigDecimal totalBudget = dto.getTotalBudget() != null
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
            return TripMapper.toResponse(tripRepository.save(trip));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public TripResponse update(TripRequest dto) {
        if (dto == null) {
            throw new IllegalArgumentException("TripRequest must be not null");
        }
        if (dto.getId() == null) {
            throw new IllegalArgumentException("Id is required to update");
        }
        Trip existing = tripRepository.findByIdAndIsDeletedFalse(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("TripId not found or has been deleted"));

        if (isTerminal(existing.getTripStatus())) {
            throw new IllegalArgumentException("Trip is read-only in terminal state");
        }
        if (dto.getDestination() != null)
            existing.setDestination(trimToNull(dto.getDestination()));
        if (dto.getStartDate() != null)
            existing.setStartDate(dto.getStartDate());
        if (dto.getDuration() != null) {
            if (dto.getDuration() <= 0)
                throw new IllegalArgumentException("Duration must not be <= 0");
            existing.setDuration(dto.getDuration());
        }
        // ✅ CẬP NHẬT: Xử lý thay đổi số lượng người tham gia
        if (dto.getTravelerCount() != null) {
            if (dto.getTravelerCount() <= 0)
                throw new IllegalArgumentException("Traveler count must not be <= 0");
            existing.setTravelerCount(dto.getTravelerCount());
        }
        if (dto.getTotalBudget() != null) {
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
            return TripMapper.toResponse(tripRepository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public TripResponse findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("Id must not be null");
        return tripRepository.findByIdAndIsDeletedFalse(id)
                .map(TripMapper::toResponse)
                .orElse(null);
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

    /**
     * ✅ THAY ĐỔI: Thực hiện logic Xóa Mềm thay vì xóa vật lý dữ liệu
     */
    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("Id is required");

        // Sử dụng hàm Custom @Modifying trong Repository để tối ưu hiệu năng hạ tầng dữ
        // liệu
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
}