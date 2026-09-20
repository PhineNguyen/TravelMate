package com.travelmate.backend.controller;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.travelmate.backend.config.DataSeeder;
import com.travelmate.backend.dto.CurrentWeatherDTO;
import com.travelmate.backend.entity.*;
import com.travelmate.backend.repository.*;
import com.travelmate.backend.service.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.ValueSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerMapping;

import java.util.*;
import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@Transactional
class ApiContractIntegrationTest {
    @Autowired MockMvc mvc;
    @Autowired ObjectMapper json;
    @Autowired RequestMappingHandlerMapping mappings;
    @Autowired TripTemplateRepository templates;
    @Autowired TemplateItemRepository templateItems;
    @Autowired PlaceRepository places;
    @Autowired jakarta.persistence.EntityManager em;
    @MockBean DataSeeder seeder;
    @MockBean AiServiceClient ai;
    @MockBean WeatherApiClientService weather;
    @MockBean PasswordResetMailService mail;

    static final String CONTRACT = """
            POST /api/auth/register
            POST /api/auth/login
            POST /api/auth/oauth
            POST /api/auth/forgot-password
            POST /api/auth/reset-password
            DELETE /api/auth/logout
            GET /api/users/{id}
            PUT /api/users/{id}
            DELETE /api/users/{id}
            POST /api/user-preferences
            GET /api/user-preferences/user/{userId}
            PUT /api/user-preferences/{id}
            POST /api/trips
            GET /api/trips
            GET /api/trips/{id}
            PUT /api/trips/{id}
            DELETE /api/trips/{id}
            PUT /api/trips/{id}/restore
            POST /api/itinerary-items
            GET /api/itinerary-items/{id}
            GET /api/itinerary-items/trip/{tripId}
            PUT /api/itinerary-items/reorder
            PUT /api/itinerary-items/{id}
            DELETE /api/itinerary-items/{id}
            POST /api/expenses
            GET /api/expenses/trip/{tripId}
            PUT /api/expenses/{id}
            DELETE /api/expenses/{id}
            GET /api/places
            POST /api/places
            GET /api/trip-templates
            GET /api/template-items/template/{id}
            POST /api/ai-conversations
            GET /api/ai-conversations/trip/{tripId}
            POST /api/ai-messages/send
            GET /api/insights/trips/{tripId}/budget
            GET /api/insights/trips/{tripId}/runtime
            GET /api/weather/trip/{tripId}
            """;

    @Test void exposesExactlyTheRequested38Operations() {
        Set<String> actual = new TreeSet<>();
        mappings.getHandlerMethods().forEach((mapping, handler) -> {
            mapping.getPatternValues().stream().filter(p -> p.startsWith("/api/")).forEach(path ->
                    mapping.getMethodsCondition().getMethods().forEach(method -> actual.add(method + " " + path)));
        });
        assertThat(actual).containsExactlyInAnyOrderElementsOf(CONTRACT.lines().toList());
    }

    @Test void allPrivateOperationsRequireAuthentication() throws Exception {
        for (String operation : CONTRACT.lines().toList()) {
            if (operation.startsWith("POST /api/auth/")) continue;
            String[] parts = operation.split(" ");
            mvc.perform(request(org.springframework.http.HttpMethod.valueOf(parts[0]),
                    parts[1].replaceAll("\\{[^}]+}", "1")))
                    .andExpect(status().isUnauthorized());
        }
    }

    record Account(long id, String token, String email) {}

    Account register() throws Exception {
        String email = UUID.randomUUID() + "@example.com";
        JsonNode result = call(post("/api/auth/register"), null,
                Map.of("fullName", "API Test", "email", email, "password", "Password123"), 200);
        return new Account(result.at("/user/id").asLong(), result.get("accessToken").asText(), email);
    }

    JsonNode call(MockHttpServletRequestBuilder request, Account account, Object body, int status) throws Exception {
        if (account != null) request.header("Authorization", "Bearer " + account.token());
        if (body != null) request.contentType(MediaType.APPLICATION_JSON).content(json.writeValueAsString(body));
        String content = mvc.perform(request).andExpect(status().is(status)).andReturn().getResponse().getContentAsString();
        return content.isBlank() ? json.nullNode() : json.readTree(content);
    }

    long trip(Account account) throws Exception {
        String today = java.time.LocalDate.now().toString();
        return call(post("/api/trips"), account, Map.of("destination", "Hanoi", "startDate", today,
                "endDate", today, "duration", 1, "travelerCount", 1, "totalBudget", 1000,
                "planningMode", "MANUAL"), 201).get("id").asLong();
    }

    @Test void tripItineraryExpenseAndInsightsLifecycle() throws Exception {
        Account owner = register();
        long trip = trip(owner);
        assertThat(call(get("/api/trips"), owner, null, 200)).hasSize(1);
        call(get("/api/trips/" + trip), owner, null, 200);
        assertThat(call(put("/api/trips/" + trip), owner, Map.of("totalBudget", 2000), 200)
                .get("totalBudget").asInt()).isEqualTo(2000);
        long place = call(post("/api/places"), owner, Map.of("name", "Test Lake", "city", "Hanoi",
                "country", "Vietnam", "latitude", 21.0, "longitude", 105.0), 201).get("id").asLong();
        assertThat(call(get("/api/places").param("query", "Test Lake"), owner, null, 200)).hasSize(1);
        assertThat(call(get("/api/places").param("query", "missing-name"), owner, null, 200)).isEmpty();
        long item = call(post("/api/itinerary-items"), owner, Map.of("tripId", trip, "placeId", place,
                "dayNumber", 1, "orderIndex", 1, "startTime", "23:59:00"), 201).get("id").asLong();
        assertThat(call(get("/api/itinerary-items/" + item), owner, null, 200)
                .at("/place/name").asText()).isEqualTo("Test Lake");
        call(put("/api/itinerary-items/" + item), owner, Map.of("note", "Updated"), 200);
        call(put("/api/itinerary-items/reorder"), owner,
                List.of(Map.of("id", item, "dayNumber", 1, "orderIndex", 2)), 200);
        assertThat(call(get("/api/itinerary-items/trip/" + trip), owner, null, 200).get(0)
                .get("orderIndex").asInt()).isEqualTo(2);
        var expenseBody = new HashMap<String, Object>(Map.of("tripId", trip, "createdById", owner.id(),
                "amount", 100, "category", "FOOD"));
        long expense = call(post("/api/expenses"), owner, expenseBody, 201).get("id").asLong();
        expenseBody.put("amount", 250);
        call(put("/api/expenses/" + expense), owner, expenseBody, 200);
        assertThat(call(get("/api/expenses/trip/" + trip), owner, null, 200).get("content")).hasSize(1);
        assertThat(call(get("/api/insights/trips/" + trip + "/budget"), owner, null, 200)
                .get("spentBudget").asInt()).isEqualTo(250);
        assertThat(call(get("/api/insights/trips/" + trip + "/runtime"), owner, null, 200)
                .get("googleMapsUrl").asText()).contains("destination=21.0%2C105.0");
        when(weather.fetchCurrentWeather(21, 105)).thenReturn(CurrentWeatherDTO.fallback(21.0, 105.0));
        call(get("/api/weather/trip/" + trip), owner, null, 200);
        verify(weather).fetchCurrentWeather(21, 105);
        call(delete("/api/expenses/" + expense), owner, null, 204);
        assertThat(call(get("/api/insights/trips/" + trip + "/budget"), owner, null, 200)
                .get("spentBudget").asInt()).isZero();
        call(delete("/api/itinerary-items/" + item), owner, null, 204);
        call(get("/api/itinerary-items/" + item), owner, null, 404);
        call(delete("/api/trips/" + trip), owner, null, 204);
        assertThat(call(get("/api/trips"), owner, null, 200)).isEmpty();
        call(put("/api/trips/" + trip + "/restore"), owner, null, 200);
        assertThat(call(get("/api/trips"), owner, null, 200)).hasSize(1);
    }

    @Test void profilePreferencesChatAndTemplates() throws Exception {
        Account owner = register();
        call(get("/api/users/" + owner.id()), owner, null, 200);
        call(put("/api/users/" + owner.id()), owner, Map.of("fullName", "Updated Name"), 200);
        long pref = call(post("/api/user-preferences"), owner,
                Map.of("preferredStyle", "Culture", "minBudget", 100, "maxBudget", 1000), 201).get("id").asLong();
        call(get("/api/user-preferences/user/" + owner.id()), owner, null, 200);
        call(put("/api/user-preferences/" + pref), owner, Map.of("maxBudget", 2000), 200);
        long trip = trip(owner);
        long conv = call(post("/api/ai-conversations"), owner,
                Map.of("userId", owner.id(), "tripId", trip, "sessionTitle", "Planning"), 201).get("id").asLong();
        when(ai.getChatReply(anyString(), anyString(), anyString(), any())).thenReturn("Visit the lake");
        assertThat(call(post("/api/ai-messages/send"), owner,
                Map.of("conversationId", conv, "content", "What to visit?"), 200).get("content").asText())
                .isEqualTo("Visit the lake");
        assertThat(call(get("/api/ai-conversations/trip/" + trip), owner, null, 200)
                .get(0).get("messages")).hasSize(2);
        call(get("/api/trip-templates"), owner, null, 200);
        TripTemplate template = new TripTemplate();
        template.setTitle("Test template");
        template.setCategory("Culture");
        template.setDestination("Hanoi");
        template.setDuration(1);
        template = templates.saveAndFlush(template);
        call(get("/api/template-items/template/" + template.getId()), owner, null, 200);
    }

    @Test void loginPasswordResetLogoutAndAccountDeletion() throws Exception {
        Account owner = register();
        call(post("/api/auth/login"), null, Map.of("email", owner.email(), "password", "Password123"), 200);
        var reset = call(post("/api/auth/forgot-password"), null, Map.of("email", owner.email()), 200);
        verify(mail).sendResetMail(any(), anyString(), any());
        call(post("/api/auth/reset-password"), null,
                Map.of("resetToken", reset.get("resetToken").asText(), "newPassword", "NewPassword456"), 204);
        call(post("/api/auth/reset-password"), null,
                Map.of("resetToken", reset.get("resetToken").asText(), "newPassword", "OtherPassword789"), 400);
        JsonNode login = call(post("/api/auth/login"), null,
                Map.of("email", owner.email(), "password", "NewPassword456"), 200);
        owner = new Account(owner.id(), login.get("accessToken").asText(), owner.email());
        call(delete("/api/auth/logout"), owner, null, 204);
        call(get("/api/users/" + owner.id()), owner, null, 401);
        Account disposable = register();
        call(delete("/api/users/" + disposable.id()), disposable, null, 204);
        call(get("/api/users/" + disposable.id()), disposable, null, 401);
    }

    @Test void rejectsCrossAccountAccessAndInvalidInput() throws Exception {
        Account owner = register();
        long trip = trip(owner);
        long item = call(post("/api/itinerary-items"), owner,
                Map.of("tripId", trip, "dayNumber", 1, "orderIndex", 1), 201).get("id").asLong();
        long conv = call(post("/api/ai-conversations"), owner,
                Map.of("userId", owner.id(), "tripId", trip), 201).get("id").asLong();
        Account other = register();
        assertThat(call(get("/api/trips"), other, null, 200)).isEmpty();
        for (String path : List.of("/api/trips/" + trip, "/api/users/" + owner.id(),
                "/api/expenses/trip/" + trip, "/api/itinerary-items/trip/" + trip,
                "/api/ai-conversations/trip/" + trip, "/api/weather/trip/" + trip)) {
            call(get(path), other, null, 403);
        }
        call(delete("/api/users/" + owner.id()), other, null, 403);
        call(delete("/api/itinerary-items/" + item), other, null, 403);
        call(post("/api/ai-messages/send"), other, Map.of("conversationId", conv, "content", "Hello"), 403);
        call(put("/api/itinerary-items/reorder"), owner, List.of(Map.of("id", item)), 400);
        call(post("/api/trips"), owner, Map.of(), 400);
        call(post("/api/ai-conversations"), owner, Map.of("userId", owner.id()), 400);
        call(get("/api/weather/trip/" + trip), owner, null, 400);
        call(post("/api/auth/oauth"), null, Map.of(), 400);
        verifyNoInteractions(ai, weather);
    }

    @Test void templateAndAiModesCreateItineraryItems() throws Exception {
        Account owner = register();
        Place place = places.saveAndFlush(Place.builder().name("Template Place").isActive(true).build());
        TripTemplate template = templates.saveAndFlush(TripTemplate.builder().title("One day")
                .destination("Hanoi").category("Culture").duration(1).build());
        templateItems.saveAndFlush(TemplateItem.builder().template(template).place(place)
                .dayNumber(1).orderIndex(1).note("From template").build());
        assertThat(call(get("/api/template-items/template/" + template.getId()), owner, null, 200))
                .hasSize(1);
        String today = java.time.LocalDate.now().toString();
        var body = new HashMap<String, Object>(Map.of("destination", "Hanoi", "startDate", today,
                "endDate", today, "duration", 1, "travelerCount", 1, "planningMode", "TEMPLATE",
                "templateId", template.getId()));
        long fromTemplate = call(post("/api/trips"), owner, body, 201).get("id").asLong();
        assertThat(call(get("/api/itinerary-items/trip/" + fromTemplate), owner, null, 200).get(0)
                .get("sourceType").asText()).isEqualTo("TEMPLATE");
        var activity = com.travelmate.backend.dto.response.AiItineraryGenerateResponse.AiActivity.builder()
                .place_name("AI Place").start_time("09:00").duration_minutes(60).build();
        var day = com.travelmate.backend.dto.response.AiItineraryGenerateResponse.DayItinerary.builder()
                .day(1).activities(List.of(activity)).build();
        when(ai.generateItinerary(anyString(), anyInt(), anyDouble(), any(), anyInt(), any()))
                .thenReturn(com.travelmate.backend.dto.response.AiItineraryGenerateResponse.builder()
                        .itinerary(List.of(day)).build());
        body.put("planningMode", "AI");
        body.remove("templateId");
        long fromAi = call(post("/api/trips"), owner, body, 201).get("id").asLong();
        assertThat(call(get("/api/itinerary-items/trip/" + fromAi), owner, null, 200).get(0)
                .get("sourceType").asText()).isEqualTo("AI");
    }

    @Test void deletingPopulatedAccountRemovesDependentRecords() throws Exception {
        Account owner = register();
        long trip = trip(owner);
        call(post("/api/itinerary-items"), owner, Map.of("tripId", trip, "dayNumber", 1, "orderIndex", 1), 201);
        call(post("/api/expenses"), owner,
                Map.of("tripId", trip, "createdById", owner.id(), "amount", 10, "category", "FOOD"), 201);
        call(post("/api/ai-conversations"), owner, Map.of("tripId", trip, "userId", owner.id()), 201);
        em.flush();
        em.clear();
        call(delete("/api/users/" + owner.id()), owner, null, 204);
        em.flush();
        em.clear();
        call(get("/api/users/" + owner.id()), owner, null, 401);
    }

    @ParameterizedTest
    @ValueSource(strings = {"/api/weather/current", "/api/ai-messages/1", "/api/ai-messages",
            "/api/ai-conversations", "/api/ai-conversations/1", "/api/template-items",
            "/api/template-items/1", "/api/places/1", "/api/trip-templates/1", "/api/expenses/1", "/api/expenses"})
    void removedReadEndpointsAreUnavailable(String path) throws Exception {
        Account owner = register();
        int status = mvc.perform(get(path).header("Authorization", "Bearer " + owner.token()))
                .andReturn().getResponse().getStatus();
        assertThat(status).isIn(404, 405);
    }
}
