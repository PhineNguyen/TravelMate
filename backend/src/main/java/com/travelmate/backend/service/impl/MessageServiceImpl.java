package com.travelmate.backend.service.impl;

import com.travelmate.backend.dto.MessageDTO;
import com.travelmate.backend.entity.ChatRoom;
import com.travelmate.backend.entity.Message;
import com.travelmate.backend.entity.User;
import com.travelmate.backend.repository.ChatRoomRepository;
import com.travelmate.backend.repository.MessageRepository;
import com.travelmate.backend.repository.UserRepository;
import com.travelmate.backend.service.MessageService;
import com.travelmate.backend.mapper.MessageMapper;

import lombok.RequiredArgsConstructor;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MessageServiceImpl implements MessageService {

    private final MessageRepository repository;
    private final ChatRoomRepository chatRoomRepository;
    private final UserRepository userRepository;

    @Override
    @Transactional
    public MessageDTO create(MessageDTO dto) {
        if (dto == null)
            throw new IllegalArgumentException("MessageDTO must not be null");
        if (dto.getId() != null)
            throw new IllegalArgumentException("id must be null when creating");
        if (dto.getRoomId() == null)
            throw new IllegalArgumentException("roomId is required");
        if (dto.getSenderId() == null)
            throw new IllegalArgumentException("senderId is required");

        ChatRoom room = chatRoomRepository.findById(dto.getRoomId())
                .orElseThrow(() -> new IllegalArgumentException("ChatRoom not found"));
        User sender = userRepository.findById(dto.getSenderId())
                .orElseThrow(() -> new IllegalArgumentException("User not found"));

        if (dto.getContent() != null && dto.getContent().length() > 20000)
            throw new IllegalArgumentException("content too long");

        Message m = Message.builder()
                .room(room)
                .sender(sender)
                .content(dto.getContent())
                .messageType(dto.getMessageType())
                .isEdited(dto.getIsEdited() != null ? dto.getIsEdited() : false)
                .isDeleted(dto.getIsDeleted() != null ? dto.getIsDeleted() : false)
                .attachmentUrl(dto.getAttachmentUrl())
                .build();

        try {
            return MessageMapper.toDto(repository.save(m));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional
    public MessageDTO update(MessageDTO dto) {
        if (dto == null || dto.getId() == null)
            throw new IllegalArgumentException("id is required to update");
        Message existing = repository.findById(dto.getId())
                .orElseThrow(() -> new IllegalArgumentException("Message not found"));
        if (dto.getContent() != null) {
            existing.setContent(dto.getContent());
            existing.setEdited(true);
            existing.setEditedAt(LocalDateTime.now());
        }
        if (dto.getMessageType() != null)
            existing.setMessageType(dto.getMessageType());
        if (dto.getIsEdited() != null) {
            existing.setEdited(dto.getIsEdited());
            if (dto.getIsEdited())
                existing.setEditedAt(LocalDateTime.now());
        }
        if (dto.getIsDeleted() != null && dto.getIsDeleted() != existing.isDeleted())
            existing.setDeleted(dto.getIsDeleted());
        if (dto.getAttachmentUrl() != null)
            existing.setAttachmentUrl(dto.getAttachmentUrl());

        try {
            return MessageMapper.toDto(repository.save(existing));
        } catch (DataIntegrityViolationException ex) {
            throw new IllegalArgumentException("Database constraint violated", ex);
        }
    }

    @Override
    @Transactional(readOnly = true)
    public MessageDTO findById(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        return repository.findById(id).map(MessageMapper::toDto).orElse(null);
    }

    @Override
    @Transactional(readOnly = true)
    public List<MessageDTO> listAll() {
        return repository.findAll().stream().map(MessageMapper::toDto).collect(Collectors.toList());
    }

    @Override
    @Transactional
    public void delete(Long id) {
        if (id == null)
            throw new IllegalArgumentException("id is required");
        if (!repository.existsById(id))
            throw new IllegalArgumentException("Message not found");
        repository.deleteById(id);
    }

}
