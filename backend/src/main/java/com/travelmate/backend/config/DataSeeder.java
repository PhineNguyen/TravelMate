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

@Component
@RequiredArgsConstructor
@Slf4j
public class DataSeeder { // Xóa bỏ 'implements CommandLineRunner'

        // 1. Kho dữ liệu Người dùng & Xác thực
        private final UserRepository userRepository;
        private final UserPreferenceRepository userPreferenceRepository;
        private final OAuthAccountRepository oAuthAccountRepository;
        private final PasswordResetTokenRepository passwordResetTokenRepository;

        // 2. Kho dữ liệu Địa điểm & Mẫu chuyến đi
        private final PlaceRepository placeRepository;
        private final TripTemplateRepository tripTemplateRepository;
        private final TemplateItemRepository templateItemRepository;

        // 3. Kho dữ liệu Chuyến đi & Lịch trình
        private final TripRepository tripRepository;
        private final ItineraryItemRepository itineraryItemRepository;
        private final ExpenseRepository expenseRepository;

        // 4. Kho dữ liệu Tương tác & Trí tuệ nhân tạo (Artificial Intelligence - AI)
        private final AIConversationRepository aiConversationRepository;
        private final AIMessageRepository aiMessageRepository;


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

                        String[] templateTitles = {
                                        "Sài Gòn 3 Ngày 2 Đêm",
                                        "Hà Nội - Sapa",
                                        "Đà Nẵng - Hội An",
                                        "Hạ Long Cuối Tuần",
                                        "Khám phá Phú Quốc",
                                        "Tokyo Foodie Journey",
                                        "Bali Beach Escape",
                                        "Paris Culture Weekend",
                                        "Swiss Alps Explorer",
                                        "Kyoto Slow Travel"
                        };
                        String[] templateCategories = {
                                        "Culinary",
                                        "Nature",
                                        "Culture",
                                        "Beach",
                                        "Luxury",
                                        "Culinary",
                                        "Beach",
                                        "Culture",
                                        "Nature",
                                        "Luxury"
                        };
                        String[] templateDestinations = {
                                        "Hồ Chí Minh",
                                        "Hà Nội",
                                        "Đà Nẵng",
                                        "Hạ Long",
                                        "Phú Quốc",
                                        "Tokyo",
                                        "Bali",
                                        "Paris",
                                        "Lucerne",
                                        "Kyoto"
                        };
                        String[] descriptions = {
                                        "Khám phá trung tâm Sài Gòn sôi động.",
                                        "Hành trình từ thủ đô đến vùng núi mờ sương.",
                                        "Tận hưởng vẻ đẹp miền Trung.",
                                        "Trải nghiệm di sản thiên nhiên thế giới.",
                                        "Nghỉ dưỡng tại đảo ngọc Phú Quốc.",
                                        "Trải nghiệm ẩm thực Nhật Bản trong 4 ngày.",
                                        "Một kỳ nghỉ biển với sunset, spa và trải nghiệm địa phương.",
                                        "Lên lịch tham quan bảo tàng, quán cà phê và phố đi bộ.",
                                        "Leo núi, ngắm hồ và tận hưởng không khí Alpine.",
                                        "Khám phá đền chùa, con đường cỏ và văn hóa Nhật cổ."
                        };
                        String[] thumbnailUrls = {
                                        "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=1200",
                                        "https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=1200",
                                        "https://images.unsplash.com/photo-1509660933844-6910e1276c0f?q=80&w=1200",
                                        "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1200",
                                        "https://images.unsplash.com/photo-1500375592092-40eb2168fd21?q=80&w=1200",
                                        "https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=1200",
                                        "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1200",
                                        "https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1200",
                                        "https://images.unsplash.com/photo-1501785888041-af3ef285b470?q=80&w=1200",
                                        "https://images.unsplash.com/photo-1528164344705-47542687000d?q=80&w=1200"
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
                        for (int i = 0; i < 10; i++) {
                                TripTemplate template = TripTemplate.builder()
                                                .title(templateTitles[i])
                                                .destination(templateDestinations[i])
                                                .category(templateCategories[i])
                                                .duration(3 + (i % 4))
                                                .estimatedBudget(BigDecimal.valueOf(1500000 + i * 550000))
                                                .popularityScore(4.2 + (i * 0.18))
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

                        // 6. Bảng PasswordResetToken
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

                        // 7. Bảng TemplateItem
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

                        // ==========================================
                        // CẤP 3: BẢNG TRIP & CÁC BẢNG LIÊN QUAN ĐẾN TRIP
                        // ==========================================

                        // 10. Bảng Trip
                        List<Trip> trips = new ArrayList<>();
                        for (int i = 0; i < 8; i++) {
                                trips.add(Trip.builder()
                                                .owner(users.get(i % users.size()))
                                                .template(templates.get(i % templates.size()))
                                                .destination(templateDestinations[i % templateDestinations.length])
                                                .startDate(LocalDate.now().plusDays(i * 7))
                                                .duration(3 + (i % 5))
                                                .travelerCount(2 + (i % 4))
                                                .totalBudget(BigDecimal.valueOf(5000000 + i * 1100000))
                                                .planningMode(PlanningMode.MANUAL)
                                                .tripStatus(i % 2 == 0 ? TripStatus.PLANNED : TripStatus.ACTIVE)
                                                .isCustomized(true)
                                                .build());
                        }
                        trips = tripRepository.saveAll(trips);

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

                        log.info("Khởi tạo thành công dữ liệu mặc định phong phú.");
                }
        }
}