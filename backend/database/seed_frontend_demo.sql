BEGIN;

-- Bo du lieu nay khong xoa du lieu hien co.
-- Cac lenh co dieu kien NOT EXISTS de co the chay lai an toan.

-- 1. Users mau de lam owner/creator cua cac du lieu frontend.
INSERT INTO
    users (
        full_name,
        email,
        password,
        phone_number,
        location,
        plan,
        avatar_url,
        is_active
    )
VALUES (
        'TravelMate Demo',
        'demo@travelmate.local',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        '0900000001',
        'Ho Chi Minh City',
        'PRO',
        'https://i.pravatar.cc/150?u=travelmate-demo',
        TRUE
    ),
    (
        'Nguyen Minh Anh',
        'minhanh@travelmate.local',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        '0900000002',
        'Ha Noi',
        'FREE',
        'https://i.pravatar.cc/150?u=minhanh',
        TRUE
    ),
    (
        'Tran Gia Bao',
        'giabao@travelmate.local',
        '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
        '0900000003',
        'Da Nang',
        'FREE',
        'https://i.pravatar.cc/150?u=giabao',
        TRUE
    )
ON CONFLICT (email) DO NOTHING;

-- 2. User preferences cho flow onboarding/profile.
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
SELECT u.id, 2000000, 12000000, 5, 'Explorer', 'Culinary,Nature,Culture', 'Asia'
FROM users u
WHERE
    u.email = 'demo@travelmate.local'
    AND NOT EXISTS (
        SELECT 1
        FROM user_preferences p
        WHERE
            p.user_id = u.id
    );

-- 3. Trip templates cho man hinh Trip Templates.
INSERT INTO
    trip_template (
        title,
        destination,
        category,
        duration,
        estimated_budget,
        thumbnail_url,
        description,
        popularity_score
    )
SELECT s.title, s.destination, s.category, s.duration, s.estimated_budget, s.thumbnail_url, s.description, s.popularity_score
FROM (
        VALUES (
                'Saigon Street Food Tour', 'Ho Chi Minh City', 'Culinary', 3, 1800000.00, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?q=80&w=1200', 'Explore local markets, street food and lively neighborhoods.', 4.85
            ), (
                'Hanoi and Sapa Adventure', 'Hanoi', 'Nature', 5, 3200000.00, 'https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=1200', 'Combine Hanoi heritage with mountain views and Sapa rice terraces.', 4.72
            ), (
                'Da Nang and Hoi An Heritage', 'Da Nang', 'Culture', 4, 3600000.00, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?q=80&w=1200', 'Discover lantern streets, historic architecture and Central Vietnam cuisine.', 4.78
            ), (
                'Ha Long Bay Weekend', 'Ha Long Bay', 'Beach', 3, 4100000.00, 'https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=1200', 'Enjoy a cruise, limestone islands and sunset views across Ha Long Bay.', 4.68
            ), (
                'Phu Quoc Island Escape', 'Phu Quoc', 'Luxury', 5, 6200000.00, 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1200', 'Relax by the sea with island activities and seafood dinners.', 4.81
            ), (
                'Tokyo Foodie Journey', 'Tokyo', 'Culinary', 4, 7800000.00, 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?q=80&w=1200', 'Taste ramen, sushi and neighborhood specialties across Tokyo.', 4.90
            ), (
                'Bali Beach and Wellness', 'Bali', 'Beach', 6, 6900000.00, 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=1200', 'Balance beach time, temples, wellness sessions and island sunsets.', 4.76
            ), (
                'Paris Art and Cafe Weekend', 'Paris', 'Culture', 4, 9800000.00, 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1200', 'Visit museums, historic streets, independent cafes and landmarks.', 4.88
            ), (
                'Swiss Alps Explorer', 'Lucerne', 'Nature', 7, 12500000.00, 'https://images.unsplash.com/photo-1531366936337-7c912a4589a7?q=80&w=1200', 'Travel through mountain villages, alpine lakes and scenic rail routes.', 4.83
            ), (
                'Kyoto Slow Travel', 'Kyoto', 'Luxury', 5, 8600000.00, 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=1200', 'Experience temples, gardens, tea culture and peaceful old streets.', 4.87
            )
    ) AS s (
        title, destination, category, duration, estimated_budget, thumbnail_url, description, popularity_score
    )
WHERE
    NOT EXISTS (
        SELECT 1
        FROM trip_template t
        WHERE
            t.title = s.title
    );

-- 4. Places cho itinerary/map.
INSERT INTO
    places (
        name,
        description,
        latitude,
        longitude,
        address,
        city,
        country,
        category,
        rating,
        review_count,
        avg_cost,
        currency,
        is_indoor,
        is_active,
        image_url,
        source_provider
    )
SELECT
    s.name,
    s.description,
    s.latitude,
    s.longitude,
    s.address,
    s.city,
    'Vietnam',
    s.category,
    s.rating,
    s.review_count,
    s.avg_cost,
    'VND',
    s.is_indoor,
    TRUE,
    s.image_url,
    'TravelMate Demo'
FROM (
        VALUES (
                'Ben Thanh Market', 'Local food and shopping market.', 10.7721, 106.6980, 'Le Loi, District 1', 'Ho Chi Minh City', 'SHOPPING', 4.4, 1200, 250000.00, TRUE, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?q=80&w=900'
            ), (
                'Hoan Kiem Lake', 'Historic lake in the center of Hanoi.', 21.0285, 105.8542, 'Dinh Tien Hoang Street', 'Hanoi', 'ENTERTAINMENT', 4.7, 1800, 0.00, FALSE, 'https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=900'
            ), (
                'Hoi An Ancient Town', 'Lantern streets and heritage architecture.', 15.8801, 108.3380, 'Old Town', 'Hoi An', 'ENTERTAINMENT', 4.8, 2200, 150000.00, FALSE, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?q=80&w=900'
            ), (
                'Ha Long Bay Cruise Port', 'Starting point for bay cruises.', 20.9500, 107.0800, 'Bai Chay', 'Ha Long Bay', 'ENTERTAINMENT', 4.6, 900, 800000.00, FALSE, 'https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=900'
            ), (
                'Phu Quoc Night Market', 'Seafood and local specialties.', 10.2167, 103.9600, 'Duong Dong', 'Phu Quoc', 'FOOD', 4.5, 1100, 350000.00, FALSE, 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=900'
            )
    ) AS s (
        name, description, latitude, longitude, address, city, category, rating, review_count, avg_cost, is_indoor, image_url
    )
WHERE
    NOT EXISTS (
        SELECT 1
        FROM places p
        WHERE
            p.name = s.name
            AND p.city = s.city
    );

-- 5. Trips mau cho Home/All Trips.
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
SELECT u.id, s.destination, CURRENT_DATE + s.day_offset, s.duration, s.traveler_count, s.total_budget, 'MANUAL', t.id, TRUE, s.trip_status, FALSE, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM (
        VALUES (
                'Demo Vietnam Discovery',
                'Vietnam',
                7,
                6,
                3,
                8500000.00,
                'PLANNED'
            ),
            (
                'Demo Tokyo Food Trip',
                'Tokyo',
                28,
                4,
                2,
                12000000.00,
                'ACTIVE'
            ),
            (
                'Demo Bali Reset',
                'Bali',
                60,
                6,
                4,
                15000000.00,
                'DRAFT'
            )
    ) AS s (
        title,
        destination,
        day_offset,
        duration,
        traveler_count,
        total_budget,
        trip_status
    )
    CROSS JOIN (
        SELECT id
        FROM users
        WHERE
            email = 'demo@travelmate.local'
        LIMIT 1
    ) u
    JOIN trip_template t ON t.title = CASE s.title
        WHEN 'Demo Vietnam Discovery' THEN 'Da Nang and Hoi An Heritage'
        WHEN 'Demo Tokyo Food Trip' THEN 'Tokyo Foodie Journey'
        ELSE 'Bali Beach and Wellness'
    END
WHERE
    NOT EXISTS (
        SELECT 1
        FROM trips existing
        WHERE
            existing.destination = s.destination
            AND existing.owner_id = u.id
            AND existing.is_deleted = FALSE
    );

-- 7. Itinerary items va expense cho cac trip demo.
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
SELECT t.id, p.id, 1, TIME '09:00', 120, 'Bring water and a camera.', 150000.00, 1, 'MANUAL', FALSE, 'PLACE', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
FROM
    trips t
    JOIN places p ON p.city = CASE t.destination
        WHEN 'Vietnam' THEN 'Hoi An'
        ELSE t.destination
    END
WHERE
    t.owner_id = (
        SELECT id
        FROM users
        WHERE
            email = 'demo@travelmate.local'
        LIMIT 1
    )
    AND NOT EXISTS (
        SELECT 1
        FROM itinerary_item i
        WHERE
            i.trip_id = t.id
            AND i.day_number = 1
    );

INSERT INTO
    expenses (
        trip_id,
        created_by,
        amount,
        category,
        description,
        expense_date,
        is_deleted
    )
SELECT t.id, t.owner_id, s.amount, s.category, s.description, CURRENT_DATE, FALSE
FROM trips t
    CROSS JOIN (
        VALUES (
                450000.00, 'FOOD', 'Dinner and local specialties'
            ), (
                280000.00, 'TRANSPORT', 'Airport and city transfers'
            ), (
                650000.00, 'SHOPPING', 'Local gifts and souvenirs'
            )
    ) AS s (amount, category, description)
WHERE
    t.owner_id = (
        SELECT id
        FROM users
        WHERE
            email = 'demo@travelmate.local'
        LIMIT 1
    )
    AND NOT EXISTS (
        SELECT 1
        FROM expenses e
        WHERE
            e.trip_id = t.id
            AND e.description = s.description
    );

COMMIT;

-- Kiem tra nhanh sau khi chay.
SELECT 'trip_template' AS table_name, COUNT(*) AS total
FROM trip_template
UNION ALL
SELECT 'trips', COUNT(*)
FROM trips
UNION ALL
SELECT 'places', COUNT(*)
FROM places
UNION ALL
SELECT 'expenses', COUNT(*)
FROM expenses;