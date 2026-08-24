package com.travelmate.backend.security;

import com.travelmate.backend.service.TokenRevocationService;
import jakarta.servlet.ServletException;
import java.io.IOException;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockFilterChain;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.mock.web.MockHttpServletResponse;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.junit.jupiter.api.Assertions.assertNull;
import static org.junit.jupiter.api.Assertions.assertNotNull;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class JwtAuthenticationFilterTest {

    @Mock
    private JwtService jwtService;

    @Mock
    private UserDetailsService userDetailsService;

    @Mock
    private TokenRevocationService tokenRevocationService;

    @InjectMocks
    private JwtAuthenticationFilter jwtAuthenticationFilter;

    @AfterEach
    void clearSecurityContext() {
        SecurityContextHolder.clearContext();
    }

    @Test
    void shouldIgnoreStaleTokenWhenUserNotFound() throws ServletException, IOException {
        String token = "stale-token";
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/api/weather-snapshots/trip/1");
        request.addHeader("Authorization", "Bearer " + token);
        MockHttpServletResponse response = new MockHttpServletResponse();
        MockFilterChain filterChain = new MockFilterChain();

        when(jwtService.isAccessTokenValid(token)).thenReturn(true);
        when(jwtService.extractJti(token)).thenReturn("jti-1");
        when(tokenRevocationService.isRevoked("jti-1")).thenReturn(false);
        when(jwtService.extractEmail(token)).thenReturn("missing@travelmate.local");
        when(userDetailsService.loadUserByUsername("missing@travelmate.local"))
                .thenThrow(new UsernameNotFoundException("User not found"));

        assertDoesNotThrow(() -> jwtAuthenticationFilter.doFilter(request, response, filterChain));
        assertNull(SecurityContextHolder.getContext().getAuthentication());
    }

    @Test
    void shouldAuthenticateWhenTokenIsValid() throws ServletException, IOException {
        String token = "valid-token";
        MockHttpServletRequest request = new MockHttpServletRequest("GET", "/api/weather-snapshots/trip/1");
        request.addHeader("Authorization", "Bearer " + token);
        MockHttpServletResponse response = new MockHttpServletResponse();
        MockFilterChain filterChain = new MockFilterChain();

        UserDetails user = User.withUsername("demo@travelmate.local").password("x").authorities("ROLE_USER").build();

        when(jwtService.isAccessTokenValid(token)).thenReturn(true);
        when(jwtService.extractJti(token)).thenReturn("jti-2");
        when(tokenRevocationService.isRevoked("jti-2")).thenReturn(false);
        when(jwtService.extractEmail(token)).thenReturn("demo@travelmate.local");
        when(userDetailsService.loadUserByUsername("demo@travelmate.local")).thenReturn(user);

        jwtAuthenticationFilter.doFilter(request, response, filterChain);

        assertNotNull(SecurityContextHolder.getContext().getAuthentication());
    }
}
