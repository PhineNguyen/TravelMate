package com.travelmate.backend.dto.request;

import jakarta.validation.Validation;
import jakarta.validation.Validator;
import jakarta.validation.ValidatorFactory;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class AuthRegisterRequestValidationTest {

    private final Validator validator;

    AuthRegisterRequestValidationTest() {
        ValidatorFactory factory = Validation.buildDefaultValidatorFactory();
        this.validator = factory.getValidator();
    }

    @Test
    void registerRequestRejectsWeakPassword() {
        AuthRegisterRequest request = AuthRegisterRequest.builder()
                .fullName("Nguyen Van A")
                .email("nguyen@example.com")
                .password("weakpass")
                .build();

        var violations = validator.validate(request);

        assertFalse(violations.isEmpty());
        assertTrue(violations.stream().anyMatch(v -> v.getPropertyPath().toString().equals("password")));
    }
}
