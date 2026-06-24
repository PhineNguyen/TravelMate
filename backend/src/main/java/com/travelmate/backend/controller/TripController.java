package com.travelmate.backend.controller;

import com.travelmate.backend.dto.request.TripRequest;
import com.travelmate.backend.dto.response.TripResponse;
import com.travelmate.backend.entity.enums.TripStatus;
import com.travelmate.backend.service.TripService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/trips")
@RequiredArgsConstructor
@PreAuthorize("isAuthenticated()")
public class TripController {
    private final TripService tripService;

    @PostMapping
    public ResponseEntity<TripResponse> create(@Valid @RequestBody TripRequest dto) {
        return ResponseEntity.status(HttpStatus.CREATED).body(tripService.create(dto));
    }

    @PutMapping("/{id}")
    public ResponseEntity<TripResponse> update(@PathVariable Long id, @Valid @RequestBody TripRequest dto) {
        dto.setId(id);
        return ResponseEntity.ok(tripService.update(dto));
    }

    @GetMapping("/{id}")
    public ResponseEntity<TripResponse> get(@PathVariable Long id) {
        // Service cần viết logic chỉ lấy các trip có isDeleted = false
        TripResponse dto = tripService.findById(id);
        return dto == null ? ResponseEntity.notFound().build() : ResponseEntity.ok(dto);
    }

    /**
     * ✅ NÂNG CẤP: Lấy danh sách chuyến đi hỗ trợ Phân trang, Sắp xếp và Bộ lọc
     * (Filter)
     * URL ví dụ: /api/trips?page=0&size=10&sort=createdAt,desc&status=PLANNING
     */
    @GetMapping
    public ResponseEntity<Page<TripResponse>> list(
            @RequestParam(required = false) Long ownerId,
            @RequestParam(required = false) TripStatus status,
            @RequestParam(required = false) String destination,
            @PageableDefault(size = 10, sort = "createdAt", direction = Sort.Direction.DESC) Pageable pageable) {

        // Gọi Service xử lý lọc động theo tham số truyền lên
        Page<TripResponse> trips = tripService.searchTrips(ownerId, status, destination, pageable);
        return ResponseEntity.ok(trips);
    }

    /**
     * ✅ HÀNH ĐỘNG XÓA MỀM (Soft Delete)
     * Không xóa hẳn khỏi DB mà chuyển trạng thái isDeleted = true thông qua Service
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> delete(@PathVariable Long id) {
        tripService.delete(id); // Service sẽ gọi repository.softDeleteById(id)
        return ResponseEntity.noContent().build();
    }

    /**
     * ✅ BỔ SUNG: Khôi phục chuyến đi đã xóa mềm (Restore)
     * Một tính năng cực kỳ cần thiết khi hệ thống đã chuyển sang kiến trúc Soft
     * Delete
     */
    @PutMapping("/{id}/restore")
    public ResponseEntity<TripResponse> restore(@PathVariable Long id) {
        TripResponse restoredTrip = tripService.restore(id);
        return ResponseEntity.ok(restoredTrip);
    }
}