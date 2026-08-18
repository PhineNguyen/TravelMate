package com.travelmate.backend.config;

import com.travelmate.backend.security.JwtAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

        @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder();
        }

        @Bean
        public CorsConfigurationSource corsConfigurationSource() {
                CorsConfiguration configuration = new CorsConfiguration();
                configuration.setAllowedOriginPatterns(List.of("*"));
                configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
                configuration.setAllowedHeaders(List.of("*"));
                configuration.setAllowCredentials(true);

                UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
                source.registerCorsConfiguration("/**", configuration);
                return source;
        }

        @Bean
        public SecurityFilterChain securityFilterChain(HttpSecurity http,
                        JwtAuthenticationFilter jwtAuthenticationFilter)
                        throws Exception {
                http.csrf(csrf -> csrf.disable())
                                .cors(Customizer.withDefaults())
                                .sessionManagement(session -> session
                                                .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                                .authorizeHttpRequests(auth -> auth
                                                // 1. Mở công khai Swagger UI & OpenAPI spec
                                                .requestMatchers(
                                                                "/swagger-ui.html",
                                                                "/swagger-ui/**",
                                                                "/v3/api-docs/**",
                                                                "/swagger-resources/**",
                                                                "/webjars/**")
                                                .permitAll()

                                                // 2. Mở công khai API Auth
                                                .requestMatchers("/api/auth/**", "/api/v1/auth/**").permitAll()

                                                // 3. Cho phép đọc dữ liệu trip/template/weather từ frontend dev khi
                                                // test local
                                                .requestMatchers(HttpMethod.GET, "/api/trips", "/api/trips/**")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.GET, "/api/trip-templates",
                                                                "/api/trip-templates/**")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.GET, "/api/weather-snapshots",
                                                                "/api/weather-snapshots/**")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.GET, "/api/notifications",
                                                                "/api/notifications/**")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.GET, "/api/expenses",
                                                                "/api/expenses/**")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.GET, "/api/shared-trip-invites",
                                                                "/api/shared-trip-invites/**")
                                                .permitAll()
                                                .requestMatchers(HttpMethod.GET, "/api/analytics-snapshots",
                                                                "/api/analytics-snapshots/**")
                                                .permitAll()

                                                // 4. Mở endpoint xử lý lỗi mặc định của Spring
                                                .requestMatchers("/error").permitAll()

                                                // 5. Các API còn lại bắt buộc có JWT Token
                                                .anyRequest().authenticated())
                                .formLogin(form -> form.disable());

                http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);
                return http.build();
        }
}