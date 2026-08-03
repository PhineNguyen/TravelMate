package com.travelmate.backend.repository;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.travelmate.backend.entity.ManualActionLog;
import com.travelmate.backend.entity.enums.ManualActionType;

public interface ManualActionLogRepository extends JpaRepository<ManualActionLog, Long> {

    List<ManualActionLog> findByTripIdOrderByTimestampDesc(Long tripId);

    Page<ManualActionLog> findByTripIdOrderByTimestampDesc(Long tripId, Pageable pageable);

    List<ManualActionLog> findByUserIdOrderByTimestampDesc(Long userId);

    List<ManualActionLog> findByTargetItemIdOrderByTimestampDesc(Long targetItemId);

    List<ManualActionLog> findByActionTypeOrderByTimestampDesc(ManualActionType actionType);

    List<ManualActionLog> findByTripIdAndTimestampBetweenOrderByTimestampDesc(Long tripId, LocalDateTime from,
            LocalDateTime to);
}