package com.travelmate.backend.config;

import com.travelmate.backend.entity.*;
import com.travelmate.backend.entity.enums.*;
import com.travelmate.backend.repository.*;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

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
public class DataSeeder implements CommandLineRunner {

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

    @Override
    @Transactional
    public void run(String... args) throws Exception {
        if (userRepository.count() == 0) {
            log.info("Cơ sở dữ liệu đang trống. Bắt đầu khởi tạo dữ liệu cho 25 bảng...");

            // ==========================================
            // CẤP 1: BẢNG ĐỘC LẬP
            // ==========================================
            
            // 1. Bảng Users
            List<User> users = new ArrayList<>();
            for (int i = 1; i <= 5; i++) {
                User u = new User();
                u.setFullName("User Fullname " + i);
                u.setEmail("user" + i + "@example.com");
                u.setPassword("encodedPassword" + i);
                u.setActive(true);
                users.add(u);
            }
            users = userRepository.saveAll(users);

            // 2. Bảng Places
            List<Place> places = new ArrayList<>();
            for (int i = 1; i <= 5; i++) {
                places.add(Place.builder()
                        .name("Place " + i)
                        .address("Address " + i)
                        .city("City " + i)
                        .category(ExpenseCategory.values()[0])
                        .latitude(10.0 + i)
                        .longitude(106.0 + i)
                        .isActive(true)
                        .isIndoor(false)
                        .build());
            }
            places = placeRepository.saveAll(places);

            // 3. Bảng TripTemplate (Độc lập)
            List<TripTemplate> templates = new ArrayList<>();
            for (int i = 1; i <= 5; i++) {
                TripTemplate template = TripTemplate.builder()
                        .title("Template " + i)
                        .destination("Destination " + i)
                        .category("Category " + i)
                        .duration(3 + i)
                        .estimatedBudget(BigDecimal.valueOf(1500000))
                        .popularityScore(4.5)
                        .description("Template Description " + i)
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
                        .minBudget(BigDecimal.valueOf(500000))
                        .maxBudget(BigDecimal.valueOf(2000000))
                        .avgTripDays(4)
                        .preferredStyle("Relaxation")
                        .favoriteCategories("Nature, Food")
                        .preferredRegion("South")
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
                        .tokenHash("tokenHash" + i)
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
                        .tokenHash("resetTokenHash" + i)
                        .expiresAt(LocalDateTime.now().plusHours(2))
                        .used(false)
                        .build();
                prTokens.add(prt);
            }
            passwordResetTokenRepository.saveAll(prTokens);

            // 8. Bảng TemplateItem (Cần templates và places)
            List<TemplateItem> templateItems = new ArrayList<>();
            for (int i = 0; i < 5; i++) {
                TemplateItem item = TemplateItem.builder()
                        .template(templates.get(i))
                        .place(places.get(i))
                        .dayNumber(1)
                        .orderIndex(i)
                        .isOptional(false)
                        .build();
                templateItems.add(item);
            }
            templateItemRepository.saveAll(templateItems);

            // 9. Bảng Notification (Cần user)
            List<Notification> notifications = new ArrayList<>();
            for (int i = 0; i < 5; i++) {
                Notification notif = Notification.builder()
                        .user(users.get(i))
                        .title("Notification Title " + i)
                        .body("Notification Body " + i)
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
                        .destination("Destination " + i)
                        .startDate(LocalDate.now().plusDays(i))
                        .duration(3 + i)
                        .travelerCount(2)
                        .totalBudget(BigDecimal.valueOf(1000000))
                        .planningMode(PlanningMode.values()[0])
                        .tripStatus(TripStatus.values()[0])
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
                        .receiverEmail("receiver" + i + "@example.com")
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
                        .amount(BigDecimal.valueOf(500000))
                        .category(ExpenseCategory.values()[0])
                        .expenseDate(LocalDate.now())
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
                        .orderIndex(i)
                        .startTime(LocalTime.of(8, 0))
                        .duration(120)
                        .sourceType(SourceType.values()[0])
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

            // 16. Bảng RouteNode (Cần RoutePlan và Place)
            List<RouteNode> routeNodes = new ArrayList<>();
            for (int i = 0; i < 5; i++) {
                RouteNode node = RouteNode.builder()
                        .routePlan(routePlans.get(i))
                        .place(places.get(i))
                        .sequenceOrder(i)
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

            // 18. Bảng Message (Cần ChatRoom và User)
            List<Message> messages = new ArrayList<>();
            for (int i = 0; i < 5; i++) {
                Message msg = Message.builder()
                        .room(chatRooms.get(i))
                        .sender(users.get(i))
                        .content("Message content " + i)
                        .messageType(MessageType.TEXT)
                        .build();
                messages.add(msg);
            }
            messageRepository.saveAll(messages);

            // 19. Bảng AIConversation (Cần User và Trip)
            List<AIConversation> aiConversations = new ArrayList<>();
            for (int i = 0; i < 5; i++) {
                AIConversation aiConv = AIConversation.builder()
                        .user(users.get(i))
                        .trip(trips.get(i))
                        .sessionTitle("AI Conversation " + i)
                        .build();
                aiConversations.add(aiConv);
            }
            aiConversations = aiConversationRepository.saveAll(aiConversations);

            // 20. Bảng AIMessage (Cần AIConversation)
            List<AIMessage> aiMessages = new ArrayList<>();
            for (int i = 0; i < 5; i++) {
                AIMessage aiMsg = AIMessage.builder()
                        .conversation(aiConversations.get(i))
                        .senderType(SenderType.USER)
                        .content("Hello AI " + i)
                        .build();
                aiMessages.add(aiMsg);
            }
            aiMessageRepository.saveAll(aiMessages);

            // 21. Bảng RecommendationHistory (Cần User, Trip và Place)
            List<RecommendationHistory> recHistories = new ArrayList<>();
            for (int i = 0; i < 5; i++) {
                RecommendationHistory history = RecommendationHistory.builder()
                        .user(users.get(i))
                        .trip(trips.get(i))
                        .place(places.get(i))
                        .score(0.85)
                        .sourceEngine("collaborative_filtering")
                        .build();
                recHistories.add(history);
            }
            recommendationHistoryRepository.saveAll(recHistories);

            // 22. Bảng WeatherSnapshot (Cần Trip)
            List<WeatherSnapshot> weatherSnapshots = new ArrayList<>();
            for (int i = 0; i < 5; i++) {
                WeatherSnapshot ws = WeatherSnapshot.builder()
                        .trip(trips.get(i))
                        .date(LocalDate.now().plusDays(i))
                        .temperature(28.5)
                        .isOutdoorSafe(true)
                        .build();
                weatherSnapshots.add(ws);
            }
            weatherSnapshots = weatherSnapshotRepository.saveAll(weatherSnapshots);

            // 23. Bảng WeatherAlert (Cần Trip và WeatherSnapshot)
            List<WeatherAlert> weatherAlerts = new ArrayList<>();
            for (int i = 0; i < 5; i++) {
                WeatherAlert alert = WeatherAlert.builder()
                        .trip(trips.get(i))
                        .snapshot(weatherSnapshots.get(i))
                        .severity(AlertSeverity.MEDIUM)
                        .alertType(AlertType.RAIN)
                        .suggestedAction("Stay indoors")
                        .isResolved(false)
                        .build();
                weatherAlerts.add(alert);
            }
            weatherAlertRepository.saveAll(weatherAlerts);

            // 24. Bảng AnalyticsSnapshot (Cần Trip)
            List<AnalyticsSnapshot> analytics = new ArrayList<>();
            for (int i = 0; i < 5; i++) {
                AnalyticsSnapshot metric = AnalyticsSnapshot.builder()
                        .trip(trips.get(i))
                        .totalTrips(10)
                        .build();
                analytics.add(metric);
            }
            analyticsSnapshotRepository.saveAll(analytics);

            // 25. Bảng ManualActionLog (Cần User, Trip và ItineraryItem)
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

            log.info("Khởi tạo thành công dữ liệu mặc định cho toàn bộ 25 bảng.");
        }
    }
}