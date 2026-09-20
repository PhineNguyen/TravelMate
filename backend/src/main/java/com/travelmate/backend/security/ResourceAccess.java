package com.travelmate.backend.security;

import com.travelmate.backend.entity.Trip;
import com.travelmate.backend.repository.TripRepository;
import com.travelmate.backend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class ResourceAccess {
    private final UserRepository users;
    private final TripRepository trips;

    public Long currentUserId() {
        var auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) throw new IllegalStateException("Authentication required");
        return users.findByEmailAndActiveTrue(auth.getName())
                .orElseThrow(() -> new IllegalStateException("User not found")).getId();
    }

    public void user(Long id) {
        if (!currentUserId().equals(id)) throw new AccessDeniedException("Access denied for this user");
    }

    public Trip trip(Long id) {
        if (id == null) throw new IllegalArgumentException("tripId is required");
        Trip trip = trips.findByIdAndIsDeletedFalse(id)
                .orElseThrow(() -> new java.util.NoSuchElementException("Trip not found"));
        user(trip.getOwner().getId());
        return trip;
    }
}
