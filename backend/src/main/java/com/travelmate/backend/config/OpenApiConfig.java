package com.travelmate.backend.config;

import io.swagger.v3.oas.models.Components; // <-- NEW IMPORT
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement; // <-- NEW IMPORT
import io.swagger.v3.oas.models.security.SecurityScheme; // <-- NEW IMPORT
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

        @Bean
        public OpenAPI appOpenAPI() {
                final String securitySchemeName = "bearerAuth";

                return new OpenAPI()
                                .info(new Info().title("TravelMate API").version("v1").description("API docs"))
                                // 1. Force Swagger to look for authorization globally
                                .addSecurityItem(new SecurityRequirement().addList(securitySchemeName))
                                // 2. Define what that authorization looks like (JWT Bearer Token)
                                .components(new Components()
                                                .addSecuritySchemes(securitySchemeName,
                                                                new SecurityScheme()
                                                                                .name(securitySchemeName)
                                                                                .type(SecurityScheme.Type.HTTP)
                                                                                .scheme("bearer")
                                                                                .bearerFormat("JWT")));
        }

        @Bean
        public GroupedOpenApi publicApi() {
                return GroupedOpenApi.builder()
                                .group("public")
                                .packagesToScan("com.travelmate.backend.controller")
                                .build();
        }
}