package com.travelmate.backend.service;

import com.travelmate.backend.dto.request.TripRequest;
import com.travelmate.backend.dto.response.TripResponse;
import com.travelmate.backend.entity.enums.TripStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface TripService {

    TripResponse create(TripRequest dto);

    TripResponse update(TripRequest dto);

    TripResponse findById(Long id);

    List<TripResponse> listAll();

    /**
     * Tìm kiếm, lọc động và phân trang danh sách chuyến đi (Chưa xóa)
     * Phục vụ cho hàm list() nâng cấp ở TripController
     */
    Page<TripResponse> searchTrips(Long ownerId, TripStatus status, String destination, Pageable pageable);

    /**
     * Hàm này giờ sẽ thực hiện xóa mềm (Soft Delete)
     * Chuyển trạng thái isDeleted = true thay vì xóa vật lý khỏi DB
     */
    void delete(Long id);

    /**
     * Khôi phục chuyến đi đã bị xóa mềm
     * Chuyển trạng thái isDeleted về false và deletedAt về null
     */
    TripResponse restore(Long id);
}