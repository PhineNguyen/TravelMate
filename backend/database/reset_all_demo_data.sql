-- RESET VA NAP DU LIEU DEMO DAY DU CHO TOAN BO BANG
-- CANH BAO: XOA TOAN BO DU LIEU NGHIEP VU. CHI DUNG CHO DEVELOPMENT/DEMO.
-- Khong xoa schema va khong xoa Docker volume.
-- Chay bang psql voi working directory la thu muc database.

\set ON_ERROR_STOP on

-- Luu y ve ten bang template:
-- Entity hien tai phai dung cung ten voi cac seed SQL: trip_template.
-- Neu database dang co bang "tripTemplate", can doi @Table(name = "trip_template")
-- trong TripTemplate.java truoc khi chay script.

TRUNCATE TABLE access_token_revocations,
ai_messages,
ai_conversations,
expenses,
itinerary_item,
oauth_accounts,
password_reset_tokens,
places,
template_item,
trips,
user_preferences,
users,
trip_template RESTART IDENTITY CASCADE;

-- Seed 3 user, templates, places, 3 trip va du lieu frontend co ban.
\ir seed_frontend_demo.sql

-- Dam bao moi user demo co preferences.
INSERT INTO
    user_preferences (
        user_id,
        min_budget,
        max_budget,
        avg_trip_days,
        preferred_style,
        favorite_categories,
        preferred_region
    )
SELECT
    u.id,
    CASE u.email
        WHEN 'demo@travelmate.local' THEN 2000000
        WHEN 'minhanh@travelmate.local' THEN 3000000
        ELSE 2500000
    END,
    CASE u.email
        WHEN 'demo@travelmate.local' THEN 12000000
        WHEN 'minhanh@travelmate.local' THEN 15000000
        ELSE 10000000
    END,
    CASE u.email
        WHEN 'demo@travelmate.local' THEN 5
        WHEN 'minhanh@travelmate.local' THEN 7
        ELSE 4
    END,
    CASE u.email
        WHEN 'demo@travelmate.local' THEN 'Explorer'
        WHEN 'minhanh@travelmate.local' THEN 'Culture'
        ELSE 'Nature'
    END,
    CASE u.email
        WHEN 'demo@travelmate.local' THEN 'Culinary,Nature,Culture'
        WHEN 'minhanh@travelmate.local' THEN 'Culture,Food,History'
        ELSE 'Nature,Beach,Adventure'
    END,
    CASE u.email
        WHEN 'demo@travelmate.local' THEN 'Asia'
        WHEN 'minhanh@travelmate.local' THEN 'Vietnam'
        ELSE 'Southeast Asia'
    END
FROM users u
WHERE
    u.email IN (
        'demo@travelmate.local',
        'minhanh@travelmate.local',
        'giabao@travelmate.local'
    )
ON CONFLICT (user_id) DO
UPDATE
SET
    min_budget = EXCLUDED.min_budget,
    max_budget = EXCLUDED.max_budget,
    avg_trip_days = EXCLUDED.avg_trip_days,
    preferred_style = EXCLUDED.preferred_style,
    favorite_categories = EXCLUDED.favorite_categories,
    preferred_region = EXCLUDED.preferred_region;

-- Tao them trip cho hai user con lai neu seed frontend chi tao trip cho demo user.
INSERT INTO
    trips (
        owner_id,
        destination,
        start_date,
        duration,
        traveler_count,
        total_budget,
        planning_mode,
        template_id,
        is_customized,
        trip_status,
        is_deleted,
        created_at,
        updated_at
    )
SELECT u.id, v.destination, CURRENT_DATE + v.day_offset, v.duration, v.traveler_count, v.total_budget, 'MANUAL', t.id, TRUE, v.trip_status, FALSE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM (
        VALUES (
                'minhanh@travelmate.local',
                'Hanoi',
                14,
                5,
                2,
                9000000.00,
                'PLANNED'
            ),
            (
                'giabao@travelmate.local',
                'Da Nang',
                21,
                4,
                3,
                7500000.00,
                'DRAFT'
            )
    ) AS v (
        email,
        destination,
        day_offset,
        duration,
        traveler_count,
        total_budget,
        trip_status
    )
    JOIN users u ON u.email = v.email
    LEFT JOIN trip_template t ON t.destination = v.destination
WHERE
    NOT EXISTS (
        SELECT 1
        FROM trips existing
        WHERE
            existing.owner_id = u.id
            AND existing.destination = v.destination
    );

-- OAuth account mau, khong dung de xac thuc provider that.
INSERT INTO
    oauth_accounts (
        user_id,
        provider,
        provider_user_id,
        email,
        display_name,
        avatar_url,
        linked_at
    )
SELECT u.id, 'GOOGLE', 'demo-google-' || u.id, u.email, u.full_name, u.avatar_url, CURRENT_TIMESTAMP
FROM users u;

-- Reset token mau da hash gia lap, khong dung trong production.
INSERT INTO
    password_reset_tokens (
        user_id,
        token_hash,
        expires_at,
        used,
        created_at
    )
SELECT u.id, 'demo-reset-token-hash-' || u.id, CURRENT_TIMESTAMP + INTERVAL '30 minutes', FALSE, CURRENT_TIMESTAMP
FROM users u;

-- Template item cho cac template co place phu hop.
INSERT INTO
    template_item (
        template_id,
        place_id,
        day_number,
        order_index,
        start_time,
        duration,
        note,
        is_optional
    )
SELECT t.id, p.id, 1, 1, TIME '09:00', 120, 'Dia diem mau cho template.', FALSE
FROM trip_template t
    JOIN places p ON lower(p.city) = lower(t.destination)
WHERE
    NOT EXISTS (
        SELECT 1
        FROM template_item item
        WHERE
            item.template_id = t.id
            AND item.day_number = 1
            AND item.order_index = 1
    );

-- Itinerary mau: mot dia diem cho moi trip.
INSERT INTO
    itinerary_item (
        trip_id,
        place_id,
        day_number,
        start_time,
        duration,
        note,
        cost_estimate,
        order_index,
        source_type,
        is_locked,
        custom_type,
        created_at,
        updated_at
    )
SELECT t.id, p.id, 1, TIME '09:00', 120, 'Mang theo nuoc uong va may anh.', COALESCE(p.avg_cost, 150000.00), 1, 'MANUAL', FALSE, 'PLACE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM trips t
    LEFT JOIN places p ON lower(p.city) = lower(t.destination)
WHERE
    p.id IS NOT NULL;

-- Expense mau cho moi trip.
INSERT INTO
    expenses (
        trip_id,
        created_by,
        amount,
        category,
        description,
        expense_date,
        created_at,
        is_deleted
    )
SELECT
    t.id,
    t.owner_id,
    CASE t.destination
        WHEN 'Tokyo' THEN 850000
        WHEN 'Bali' THEN 650000
        WHEN 'Hanoi' THEN 420000
        ELSE 500000
    END,
    'FOOD',
    'Chi phi an uong mau',
    t.start_date,
    CURRENT_TIMESTAMP,
    FALSE
FROM trips t;

-- Weather snapshot theo ngay, co high/low va cac don vi thong nhat.
INSERT INTO
    ai_conversations (
        user_id,
        trip_id,
        session_title,
        created_at,
        updated_at
    )
SELECT t.owner_id, t.id, 'Goi y lich trinh ' || t.destination, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM trips t;

INSERT INTO
    ai_messages (
        conversation_id,
        sender_type,
        content,
        message_type,
        token_used,
        model_name,
        response_time_ms,
        context_data,
        confidence_score,
        created_at
    )
SELECT c.id, 'USER', 'Hay goi y lich trinh cho ' || t.destination, 'TEXT', 20, 'demo-model', 250, jsonb_build_object('destination', t.destination), 0.90, CURRENT_TIMESTAMP
FROM ai_conversations c
    JOIN trips t ON t.id = c.trip_id;

INSERT INTO
    ai_messages (
        conversation_id,
        sender_type,
        content,
        message_type,
        token_used,
        model_name,
        response_time_ms,
        context_data,
        confidence_score,
        created_at
    )
SELECT c.id, 'AI', 'Day 1: tham quan va am thuc dia phuong.', 'TEXT', 45, 'demo-model', 850, jsonb_build_object('source', 'demo'), 0.86, CURRENT_TIMESTAMP
FROM ai_conversations c;

-- access_token_revocations co tinh de trong vi day la du lieu session bao mat.
-- Khong tao token revoked mau de tranh anh huong login demo.

COMMIT;

-- Bao cao so luong du lieu sau khi nap.
SELECT 'users' AS table_name, COUNT(*) AS total
FROM users
UNION ALL
SELECT 'user_preferences', COUNT(*)
FROM user_preferences
UNION ALL
SELECT 'trip_template', COUNT(*)
FROM trip_template
UNION ALL
SELECT 'places', COUNT(*)
FROM places
UNION ALL
SELECT 'template_item', COUNT(*)
FROM template_item
UNION ALL
SELECT 'trips', COUNT(*)
FROM trips
UNION ALL
SELECT 'itinerary_item', COUNT(*)
FROM itinerary_item
UNION ALL
SELECT 'expenses', COUNT(*)
FROM expenses
UNION ALL
SELECT 'ai_conversations', COUNT(*)
FROM ai_conversations
UNION ALL
SELECT 'ai_messages', COUNT(*)
FROM ai_messages
UNION ALL
SELECT 'oauth_accounts', COUNT(*)
FROM oauth_accounts
UNION ALL
SELECT 'password_reset_tokens', COUNT(*)
FROM password_reset_tokens
UNION ALL
SELECT 'access_token_revocations', COUNT(*)
FROM access_token_revocations
ORDER BY table_name;