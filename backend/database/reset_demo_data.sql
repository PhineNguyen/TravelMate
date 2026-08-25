-- RESET DEMO DATABASE - DESTRUCTIVE SCRIPT
-- Canh bao: script nay xoa toan bo du lieu nghiep vu trong database travelmate.
-- Script khong xoa schema va khong xoa Docker volume.
-- Chi chay trong moi truong development/demo.

\set ON_ERROR_STOP on

TRUNCATE TABLE access_token_revocations,
ai_messages,
ai_conversations,
analytics_snapshot,
chat_room,
expenses,
itinerary_item,
manual_action_log,
messages,
notifications,
oauth_accounts,
password_reset_tokens,
places,
recommendation_history,
route_node,
route_plan,
shared_trip_invites,
template_item,
trip_participants,
trips,
weather_alert,
weather_snapshot,
user_preferences,
users RESTART IDENTITY CASCADE;

-- Nap users, templates, places, trips, itinerary, expense,
-- collaboration, notification va weather demo.
\ir seed_frontend_demo.sql

-- Dam bao ca 3 tai khoan demo co preferences.
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
    AND NOT EXISTS (
        SELECT 1
        FROM user_preferences p
        WHERE
            p.user_id = u.id
    );

-- Kiem tra nhanh sau khi reset.
SELECT id, full_name, email, is_active
FROM users
WHERE
    email IN (
        'demo@travelmate.local',
        'minhanh@travelmate.local',
        'giabao@travelmate.local'
    )
ORDER BY id;

SELECT
    COUNT(*) AS weather_snapshot_count,
    COUNT(DISTINCT trip_id) AS trip_count,
    COUNT(DISTINCT date) AS forecast_day_count
FROM weather_snapshot;