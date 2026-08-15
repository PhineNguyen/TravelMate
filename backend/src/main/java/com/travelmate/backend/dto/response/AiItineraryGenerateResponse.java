package com.travelmate.backend.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AiItineraryGenerateResponse {
    private String destination;
    private Integer duration_days;
    private Double estimated_total_cost;
    private String summary;
    private List<DayItinerary> itinerary;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class DayItinerary {
        private Integer day;
        private String theme;
        private List<AiActivity> activities;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class AiActivity {
        private String time;
        private String start_time;
        private Integer duration_minutes;
        private String place_name;
        private String category;
        private Double estimated_cost;
        private String description;
    }
}
