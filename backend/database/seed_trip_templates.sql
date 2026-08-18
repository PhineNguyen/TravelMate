-- Seed 10 trip templates for the TravelMate frontend.
-- Run this script after the backend has created the trip_template table.
-- Existing rows are preserved; rows with the same title are skipped.

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
SELECT seed.title, seed.destination, seed.category, seed.duration, seed.estimated_budget, seed.thumbnail_url, seed.description, seed.popularity_score
FROM (
        VALUES (
                'Saigon Street Food Tour', 'Ho Chi Minh City', 'Culinary', 3, 1800000.00, 'https://images.unsplash.com/photo-1583417319070-4a69db38a482?q=80&w=1200', 'Explore local markets, street food and the lively neighborhoods of Ho Chi Minh City.', 4.85
            ), (
                'Hanoi and Sapa Adventure', 'Hanoi', 'Nature', 5, 3200000.00, 'https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=1200', 'Combine Hanoi heritage with mountain views, rice terraces and local culture in Sapa.', 4.72
            ), (
                'Da Nang and Hoi An Heritage', 'Da Nang', 'Culture', 4, 3600000.00, 'https://images.unsplash.com/photo-1559592413-7cec4d0cae2b?q=80&w=1200', 'Discover lantern streets, historic architecture, beaches and Central Vietnam cuisine.', 4.78
            ), (
                'Ha Long Bay Weekend', 'Ha Long Bay', 'Beach', 3, 4100000.00, 'https://images.unsplash.com/photo-1528127269322-539801943592?q=80&w=1200', 'Enjoy a relaxing cruise, limestone islands and sunset views across Ha Long Bay.', 4.68
            ), (
                'Phu Quoc Island Escape', 'Phu Quoc', 'Luxury', 5, 6200000.00, 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?q=80&w=1200', 'Stay by the sea with island activities, seafood dinners and a quiet tropical escape.', 4.81
            ), (
                'Tokyo Foodie Journey', 'Tokyo', 'Culinary', 4, 7800000.00, 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?q=80&w=1200', 'Taste ramen, sushi and neighborhood specialties while exploring Tokyo after dark.', 4.90
            ), (
                'Bali Beach and Wellness', 'Bali', 'Beach', 6, 6900000.00, 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?q=80&w=1200', 'Balance beach time, temple visits, wellness sessions and memorable island sunsets.', 4.76
            ), (
                'Paris Art and Cafe Weekend', 'Paris', 'Culture', 4, 9800000.00, 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?q=80&w=1200', 'Visit iconic museums, historic streets, independent cafes and classic Paris landmarks.', 4.88
            ), (
                'Swiss Alps Explorer', 'Lucerne', 'Nature', 7, 12500000.00, 'https://images.unsplash.com/photo-1531366936337-7c912a4589a7?q=80&w=1200', 'Travel through mountain villages, alpine lakes and scenic rail routes in Switzerland.', 4.83
            ), (
                'Kyoto Slow Travel', 'Kyoto', 'Luxury', 5, 8600000.00, 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?q=80&w=1200', 'Experience Kyoto temples, traditional gardens, tea culture and peaceful old streets.', 4.87
            )
    ) AS seed (
        title, destination, category, duration, estimated_budget, thumbnail_url, description, popularity_score
    )
WHERE
    NOT EXISTS (
        SELECT 1
        FROM trip_template existing
        WHERE
            existing.title = seed.title
    );

-- Verify the inserted/available templates.
SELECT
    id,
    title,
    destination,
    category,
    duration,
    estimated_budget,
    popularity_score
FROM trip_template
ORDER BY popularity_score DESC, id ASC;