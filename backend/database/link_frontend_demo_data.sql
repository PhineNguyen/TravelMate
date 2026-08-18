BEGIN;

-- Bo sung dia diem dai dien cho cac template quoc te neu database chua co.
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
    s.country,
    s.category,
    4.7,
    500,
    s.avg_cost,
    'USD',
    FALSE,
    TRUE,
    s.image_url,
    'TravelMate Demo'
FROM (
        VALUES (
                'Tokyo Food District', 'Neighborhood food experiences in Tokyo.', 35.6762, 139.6503, 'Shinjuku', 'Tokyo', 'Japan', 'FOOD', 120.00, 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?q=80&w=900'
            ), (
                'Bali Wellness Beach', 'Beach and wellness activities in Bali.', -8.4095, 115.1889, 'Ubud', 'Bali', 'Indonesia', 'ENTERTAINMENT', 160.00, 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=900'
            ), (
                'Paris Art Walk', 'Museums and landmark walking route.', 48.8566, 2.3522, 'Central Paris', 'Paris', 'France', 'ENTERTAINMENT', 90.00, 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=900'
            ), (
                'Lucerne Alpine View', 'Mountain and lake viewpoint near Lucerne.', 47.0502, 8.3093, 'Lake Lucerne', 'Lucerne', 'Switzerland', 'ENTERTAINMENT', 140.00, 'https://images.unsplash.com/photo-1531366936337-7c912a4589a7?q=80&w=900'
            ), (
                'Kyoto Temple Walk', 'Traditional temples and gardens in Kyoto.', 35.0116, 135.7681, 'Higashiyama', 'Kyoto', 'Japan', 'ENTERTAINMENT', 80.00, 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=900'
            )
    ) AS s (
        name, description, latitude, longitude, address, city, country, category, avg_cost, image_url
    )
WHERE
    NOT EXISTS (
        SELECT 1
        FROM places p
        WHERE
            p.name = s.name
            AND p.city = s.city
    );

-- Tao lien ket TripTemplate -> Place qua bang template_item.
-- Script khong xoa du lieu va co the chay lai an toan.
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
SELECT t.id, p.id, 1, 1, TIME '09:00', 120, 'Suggested place from the trip template.', FALSE
FROM
    trip_template t
    JOIN places p ON p.city = CASE t.destination
        WHEN 'Ho Chi Minh City' THEN 'Ho Chi Minh City'
        WHEN 'Hanoi' THEN 'Hanoi'
        WHEN 'Da Nang' THEN 'Hoi An'
        WHEN 'Ha Long Bay' THEN 'Ha Long Bay'
        WHEN 'Phu Quoc' THEN 'Phu Quoc'
        WHEN 'Tokyo' THEN 'Tokyo'
        WHEN 'Bali' THEN 'Bali'
        WHEN 'Paris' THEN 'Paris'
        WHEN 'Lucerne' THEN 'Lucerne'
        WHEN 'Kyoto' THEN 'Kyoto'
        ELSE NULL
    END
WHERE
    t.title IN (
        'Saigon Street Food Tour',
        'Hanoi and Sapa Adventure',
        'Da Nang and Hoi An Heritage',
        'Ha Long Bay Weekend',
        'Phu Quoc Island Escape',
        'Tokyo Foodie Journey',
        'Bali Beach and Wellness',
        'Paris Art and Cafe Weekend',
        'Swiss Alps Explorer',
        'Kyoto Slow Travel'
    )
    AND NOT EXISTS (
        SELECT 1
        FROM template_item existing
        WHERE
            existing.template_id = t.id
            AND existing.day_number = 1
            AND existing.order_index = 1
    );

COMMIT;

-- Kiem tra lien ket template -> place -> trip.
SELECT
    t.id AS template_id,
    t.title,
    p.id AS place_id,
    p.name AS place_name,
    COUNT(DISTINCT tr.id) AS trips_using_template
FROM
    trip_template t
    LEFT JOIN template_item ti ON ti.template_id = t.id
    LEFT JOIN places p ON p.id = ti.place_id
    LEFT JOIN trips tr ON tr.template_id = t.id
    AND tr.is_deleted = FALSE
GROUP BY
    t.id,
    t.title,
    p.id,
    p.name
ORDER BY t.id;