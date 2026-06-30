package com.travelmate.backend.config;

import com.travelmate.backend.entity.*;
import com.travelmate.backend.entity.enums.*;
import com.travelmate.backend.repository.*;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.boot.context.event.ApplicationReadyEvent;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Component
@RequiredArgsConstructor
@Slf4j
public class DataSeeder { // Xóa bỏ 'implements CommandLineRunner'

        // 1. Kho dữ liệu Người dùng & Xác thực
        private final UserRepository userRepository;
        private final UserPreferenceRepository userPreferenceRepository;
        private final OAuthAccountRepository oAuthAccountRepository;
        private final RefreshTokenRepository refreshTokenRepository;
        private final PasswordResetTokenRepository passwordResetTokenRepository;

        // 2. Kho dữ liệu Địa điểm & Mẫu chuyến đi
        private final PlaceRepository placeRepository;
        private final TripTemplateRepository tripTemplateRepository;
        private final TemplateItemRepository templateItemRepository;

        // 3. Kho dữ liệu Chuyến đi & Lịch trình
        private final TripRepository tripRepository;
        private final TripParticipantRepository tripParticipantRepository;
        private final SharedTripInviteRepository sharedTripInviteRepository;
        private final ItineraryItemRepository itineraryItemRepository;
        private final RoutePlanRepository routePlanRepository;
        private final RouteNodeRepository routeNodeRepository;
        private final ExpenseRepository expenseRepository;

        // 4. Kho dữ liệu Tương tác & Trí tuệ nhân tạo (Artificial Intelligence - AI)
        private final ChatRoomRepository chatRoomRepository;
        private final MessageRepository messageRepository;
        private final NotificationRepository notificationRepository;
        private final AIConversationRepository aiConversationRepository;
        private final AIMessageRepository aiMessageRepository;
        private final RecommendationHistoryRepository recommendationHistoryRepository;

        // 5. Kho dữ liệu Thời tiết & Phân tích hệ thống
        private final WeatherSnapshotRepository weatherSnapshotRepository;
        private final WeatherAlertRepository weatherAlertRepository;
        private final AnalyticsSnapshotRepository analyticsSnapshotRepository;
        private final ManualActionLogRepository manualActionLogRepository;

        // Đổi tên hàm và bỏ tham số args, xóa @Override
        @EventListener(ApplicationReadyEvent.class)
        @Transactional
        public void seedData() throws Exception {
                if (userRepository.count() == 0) {
                        log.info("Cơ sở dữ liệu đang trống. Bắt đầu khởi tạo dữ liệu cho 25 bảng...");

                        // Hardcoded realistic data
                        String[] userNames = { "Nguyễn Văn A", "Trần Thị B", "Lê Hoàng C", "Phạm Thu D",
                                        "Hoàng Bảo E" };
                        String[] emails = { "nguyenvana@gmail.com", "tranthib@gmail.com", "lehoangc@yahoo.com",
                                        "phamthud@outlook.com", "hoangbaoe@gmail.com" };
                        String[] avatarUrls = {
                                        "https://i.pravatar.cc/150?u=nguyenvana",
                                        "https://i.pravatar.cc/150?u=tranthib",
                                        "https://i.pravatar.cc/150?u=lehoangc",
                                        "https://i.pravatar.cc/150?u=phamthud",
                                        "https://i.pravatar.cc/150?u=hoangbaoe"
                        };

                        String[] placeNames = { "Chợ Bến Thành", "Hồ Hoàn Kiếm", "Phố cổ Hội An", "Vịnh Hạ Long",
                                        "Chợ đêm Phú Quốc" };
                        String[] addresses = { "Quận 1, TP. HCM", "Quận Hoàn Kiếm, Hà Nội", "Hội An, Quảng Nam",
                                        "Hạ Long, Quảng Ninh", "Phú Quốc, Kiên Giang" };
                        String[] cities = { "Hồ Chí Minh", "Hà Nội", "Hội An", "Hạ Long", "Phú Quốc" };
                        ExpenseCategory[] categories = { ExpenseCategory.SHOPPING, ExpenseCategory.ENTERTAINMENT,
                                        ExpenseCategory.ENTERTAINMENT, ExpenseCategory.ENTERTAINMENT,
                                        ExpenseCategory.FOOD };

                        String[] templateTitles = { "Sài Gòn 3 Ngày 2 Đêm", "Hà Nội - Sapa", "Đà Nẵng - Hội An",
                                        "Hạ Long Cuối Tuần", "Khám phá Phú Quốc" };
                        String[] descriptions = {
                                        "Khám phá trung tâm Sài Gòn sôi động.",
                                        "Hành trình từ thủ đô đến vùng núi mờ sương.",
                                        "Tận hưởng vẻ đẹp miền Trung.",
                                        "Trải nghiệm di sản thiên nhiên thế giới.",
                                        "Nghỉ dưỡng tại đảo ngọc Phú Quốc."
                        };
                        String[] thumbnailUrls = {
                                        "https://example.com/saigon.jpg",
                                        "https://example.com/hanoi.jpg",
                                        "https://example.com/danang.jpg",
                                        "https://example.com/halong.jpg",
                                        "https://example.com/phuquoc.jpg"
                        };

                        // ==========================================
                        // CẤP 1: BẢNG ĐỘC LẬP
                        // ==========================================

                        // 1. Bảng Users
                        List<User> users = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                User u = new User();
                                u.setFullName(userNames[i]);
                                u.setEmail(emails[i]);
                                u.setPassword("encodedPassword" + i);
                                u.setAvatarUrl(avatarUrls[i]);
                                u.setActive(true);
                                users.add(u);
                        }
                        users = userRepository.saveAll(users);

                        // 2. Bảng Places
                        List<Place> places = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                places.add(Place.builder()
                                                .name(placeNames[i])
                                                .address(addresses[i])
                                                .city(cities[i])
                                                .category(categories[i])
                                                .latitude(10.0 + (Math.random() * 10))
                                                .longitude(105.0 + (Math.random() * 5))
                                                .isActive(true)
                                                .isIndoor(i % 2 == 0)
                                                .build());
                        }
                        places = placeRepository.saveAll(places);

                        // 3. Bảng TripTemplate
                        List<TripTemplate> templates = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                TripTemplate template = TripTemplate.builder()
                                                .title(templateTitles[i])
                                                .destination(cities[i])
                                                .category(i % 2 == 0 ? "Nghỉ dưỡng" : "Khám phá")
                                                .duration(3 + (i % 3))
                                                .estimatedBudget(BigDecimal.valueOf(2000000 + i * 500000))
                                                .popularityScore(4.0 + (i * 0.2))
                                                .description(descriptions[i])
                                                .thumbnailUrl(thumbnailUrls[i])
                                                .build();
                                templates.add(template);
                        }
                        templates = tripTemplateRepository.saveAll(templates);

                        // ==========================================
                        // CẤP 2: BẢNG PHỤ THUỘC VÀO USER HOẶC PLACE HOẶC TEMPLATE
                        // ==========================================

                        // 4. Bảng UserPreference
                        List<UserPreference> preferences = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                UserPreference pref = UserPreference.builder()
                                                .user(users.get(i))
                                                .minBudget(BigDecimal.valueOf(1000000))
                                                .maxBudget(BigDecimal.valueOf(10000000))
                                                .avgTripDays(4)
                                                .preferredStyle(i % 2 == 0 ? "Thư giãn" : "Phiêu lưu")
                                                .favoriteCategories("Ẩm thực, Phong cảnh")
                                                .preferredRegion(i % 2 == 0 ? "Miền Nam" : "Miền Bắc")
                                                .build();
                                preferences.add(pref);
                        }
                        userPreferenceRepository.saveAll(preferences);

                        // 5. Bảng OAuthAccount
                        List<OAuthAccount> oAuthAccounts = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                OAuthAccount oauth = OAuthAccount.builder()
                                                .user(users.get(i))
                                                .provider(OAuthProvider.GOOGLE)
                                                .providerUserId("providerUser" + i)
                                                .email(users.get(i).getEmail())
                                                .displayName(users.get(i).getFullName())
                                                .build();
                                oAuthAccounts.add(oauth);
                        }
                        oAuthAccountRepository.saveAll(oAuthAccounts);

                        // 6. Bảng RefreshToken
                        List<RefreshToken> refreshTokens = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                RefreshToken rt = RefreshToken.builder()
                                                .user(users.get(i))
                                                .tokenHash("tokenHash_V2_" + i)
                                                .expiryDate(LocalDateTime.now().plusDays(30))
                                                .revoked(false)
                                                .build();
                                refreshTokens.add(rt);
                        }
                        refreshTokenRepository.saveAll(refreshTokens);

                        // 7. Bảng PasswordResetToken
                        List<PasswordResetToken> prTokens = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                PasswordResetToken prt = PasswordResetToken.builder()
                                                .user(users.get(i))
                                                .tokenHash("resetTokenHash_V2_" + i)
                                                .expiresAt(LocalDateTime.now().plusHours(2))
                                                .used(false)
                                                .build();
                                prTokens.add(prt);
                        }
                        passwordResetTokenRepository.saveAll(prTokens);

                        // 8. Bảng TemplateItem
                        List<TemplateItem> templateItems = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                TemplateItem item = TemplateItem.builder()
                                                .template(templates.get(i))
                                                .place(places.get(i))
                                                .dayNumber(1 + (i % 2))
                                                .orderIndex(1)
                                                .isOptional(false)
                                                .build();
                                templateItems.add(item);
                        }
                        templateItemRepository.saveAll(templateItems);

                        // 9. Bảng Notification
                        List<Notification> notifications = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                Notification notif = Notification.builder()
                                                .user(users.get(i))
                                                .title("Cảnh báo thời tiết")
                                                .body("Dự báo có mưa tại " + cities[i] + " vào ngày mai.")
                                                .type(NotificationType.WEATHER_ALERT)
                                                .isRead(false)
                                                .build();
                                notifications.add(notif);
                        }
                        notificationRepository.saveAll(notifications);

                        // ==========================================
                        // CẤP 3: BẢNG TRIP & CÁC BẢNG LIÊN QUAN ĐẾN TRIP
                        // ==========================================

                        // 10. Bảng Trip
                        List<Trip> trips = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                trips.add(Trip.builder()
                                                .owner(users.get(i))
                                                .template(templates.get(i))
                                                .destination(cities[i])
                                                .startDate(LocalDate.now().plusDays(i * 7))
                                                .duration(3 + (i % 3))
                                                .travelerCount(2 + i)
                                                .totalBudget(BigDecimal.valueOf(5000000 + i * 1000000))
                                                .planningMode(PlanningMode.MANUAL)
                                                .tripStatus(TripStatus.PLANNED)
                                                .inviteCode(UUID.randomUUID().toString().substring(0, 8))
                                                .isCustomized(true)
                                                .isDeleted(false)
                                                .build());
                        }
                        trips = tripRepository.saveAll(trips);

                        // 11. Bảng TripParticipant
                        List<TripParticipant> participants = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                TripParticipant participant = TripParticipant.builder()
                                                .trip(trips.get(i))
                                                .user(users.get(i))
                                                .role(ParticipantRole.OWNER)
                                                .isActive(true)
                                                .build();
                                participants.add(participant);
                        }
                        tripParticipantRepository.saveAll(participants);

                        // 12. Bảng SharedTripInvite
                        List<SharedTripInvite> invites = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                SharedTripInvite invite = SharedTripInvite.builder()
                                                .trip(trips.get(i))
                                                .sender(users.get(i))
                                                .receiverEmail("friend" + i + "@example.com")
                                                .inviteCode(UUID.randomUUID().toString())
                                                .status(InviteStatus.PENDING)
                                                .build();
                                invites.add(invite);
                        }
                        sharedTripInviteRepository.saveAll(invites);

                        // 13. Bảng Expense
                        List<Expense> expenses = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                expenses.add(Expense.builder()
                                                .trip(trips.get(i))
                                                .createdBy(users.get(i))
                                                .amount(BigDecimal.valueOf(200000 + i * 50000))
                                                .category(ExpenseCategory.FOOD)
                                                .description("Ăn tối ngày " + (i + 1))
                                                .expenseDate(LocalDate.now().plusDays(i * 7))
                                                .isShared(true)
                                                .isDeleted(false)
                                                .build());
                        }
                        expenseRepository.saveAll(expenses);

                        // 14. Bảng ItineraryItem
                        List<ItineraryItem> itineraryItems = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                itineraryItems.add(ItineraryItem.builder()
                                                .trip(trips.get(i))
                                                .place(places.get(i))
                                                .dayNumber(1)
                                                .orderIndex(1)
                                                .startTime(LocalTime.of(8 + i, 0))
                                                .duration(120)
                                                .note("Mang theo nước uống và máy ảnh")
                                                .costEstimate(BigDecimal.valueOf(150000))
                                                .sourceType(SourceType.MANUAL)
                                                .isLocked(false)
                                                .build());
                        }
                        itineraryItems = itineraryItemRepository.saveAll(itineraryItems);

                        // 15. Bảng RoutePlan
                        List<RoutePlan> routePlans = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                RoutePlan plan = RoutePlan.builder()
                                                .trip(trips.get(i))
                                                .strategyType(StrategyType.FASTEST)
                                                .build();
                                routePlans.add(plan);
                        }
                        routePlans = routePlanRepository.saveAll(routePlans);

                        // 16. Bảng RouteNode
                        List<RouteNode> routeNodes = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                RouteNode node = RouteNode.builder()
                                                .routePlan(routePlans.get(i))
                                                .place(places.get(i))
                                                .sequenceOrder(1)
                                                .build();
                                routeNodes.add(node);
                        }
                        routeNodeRepository.saveAll(routeNodes);

                        // 17. Bảng ChatRoom
                        List<ChatRoom> chatRooms = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                ChatRoom room = ChatRoom.builder()
                                                .trip(trips.get(i))
                                                .build();
                                chatRooms.add(room);
                        }
                        chatRooms = chatRoomRepository.saveAll(chatRooms);

                        // 18. Bảng Message
                        List<Message> messages = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                Message msg = Message.builder()
                                                .room(chatRooms.get(i))
                                                .sender(users.get(i))
                                                .content("Mọi người chuẩn bị gì cho chuyến đi chưa?")
                                                .messageType(MessageType.TEXT)
                                                .build();
                                messages.add(msg);
                        }
                        messageRepository.saveAll(messages);

                        // 19. Bảng AIConversation
                        List<AIConversation> aiConversations = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                AIConversation aiConv = AIConversation.builder()
                                                .user(users.get(i))
                                                .trip(trips.get(i))
                                                .sessionTitle("Gợi ý lịch trình " + cities[i])
                                                .build();
                                aiConversations.add(aiConv);
                        }
                        aiConversations = aiConversationRepository.saveAll(aiConversations);

                        // 20. Bảng AIMessage
                        List<AIMessage> aiMessages = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                AIMessage aiMsgUser = AIMessage.builder()
                                                .conversation(aiConversations.get(i))
                                                .senderType(SenderType.USER)
                                                .content("Cho tôi gợi ý các món ăn ngon tại " + cities[i])
                                                .build();
                                AIMessage aiMsgBot = AIMessage.builder()
                                                .conversation(aiConversations.get(i))
                                                .senderType(SenderType.AI)
                                                .content("Bạn có thể thử hải sản, các món bún phở địa phương...")
                                                .build();
                                aiMessages.add(aiMsgUser);
                                aiMessages.add(aiMsgBot);
                        }
                        aiMessageRepository.saveAll(aiMessages);

                        // 21. Bảng RecommendationHistory
                        List<RecommendationHistory> recHistories = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                RecommendationHistory history = RecommendationHistory.builder()
                                                .user(users.get(i))
                                                .trip(trips.get(i))
                                                .place(places.get(i))
                                                .score(0.85 + (i * 0.02))
                                                .sourceEngine("collaborative_filtering")
                                                .build();
                                recHistories.add(history);
                        }
                        recommendationHistoryRepository.saveAll(recHistories);

                        // 22. Bảng WeatherSnapshot
                        List<WeatherSnapshot> weatherSnapshots = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                WeatherSnapshot ws = WeatherSnapshot.builder()
                                                .trip(trips.get(i))
                                                .date(LocalDate.now().plusDays(i * 7))
                                                .city(cities[i])
                                                .temperature(25.0 + (Math.random() * 8))
                                                .humidity(60.0 + (Math.random() * 30))
                                                .rainProbability(10.0 + (Math.random() * 50))
                                                .condition(i % 2 == 0 ? "Trời nắng" : "Trời nhiều mây")
                                                .windSpeed(15.5)
                                                .uvIndex(6.0)
                                                .visibility(10.0)
                                                .alertLevel("Bình thường")
                                                .providerName("OpenWeatherMap")
                                                .providerId("provider_" + i)
                                                .isOutdoorSafe(true)
                                                .build();
                                weatherSnapshots.add(ws);
                        }
                        weatherSnapshots = weatherSnapshotRepository.saveAll(weatherSnapshots);

                        // 23. Bảng WeatherAlert
                        List<WeatherAlert> weatherAlerts = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                WeatherAlert alert = WeatherAlert.builder()
                                                .trip(trips.get(i))
                                                .snapshot(weatherSnapshots.get(i))
                                                .severity(AlertSeverity.MEDIUM)
                                                .alertType(AlertType.RAIN)
                                                .suggestedAction("Nên mang theo ô hoặc áo mưa.")
                                                .isResolved(false)
                                                .build();
                                weatherAlerts.add(alert);
                        }
                        weatherAlertRepository.saveAll(weatherAlerts);

                        // 24. Bảng AnalyticsSnapshot
                        List<AnalyticsSnapshot> analytics = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                AnalyticsSnapshot metric = AnalyticsSnapshot.builder()
                                                .trip(trips.get(i))
                                                .totalTrips(10 + i)
                                                .build();
                                analytics.add(metric);
                        }
                        analyticsSnapshotRepository.saveAll(analytics);

                        // 25. Bảng ManualActionLog
                        List<ManualActionLog> logs = new ArrayList<>();
                        for (int i = 0; i < 5; i++) {
                                ManualActionLog logItem = ManualActionLog.builder()
                                                .user(users.get(i))
                                                .trip(trips.get(i))
                                                .targetItem(itineraryItems.get(i))
                                                .actionType(ManualActionType.ADD)
                                                .build();
                                logs.add(logItem);
                        }
                        manualActionLogRepository.saveAll(logs);

                        log.info("Khởi tạo thành công dữ liệu mặc định phong phú cho toàn bộ 25 bảng.");
                }
        }
}