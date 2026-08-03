package com.travelmate.backend.repository;

import java.util.List;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.travelmate.backend.entity.Message;

public interface MessageRepository extends JpaRepository<Message, Long> {

    Page<Message> findByRoomIdAndIsDeletedFalse(Long roomId, Pageable pageable);

    List<Message> findBySenderIdAndIsDeletedFalse(Long senderId);

    long countByRoomIdAndIsDeletedFalse(Long roomId);

    List<Message> findTop20ByRoomIdAndIsDeletedFalseOrderByCreatedAtDesc(Long roomId);
}