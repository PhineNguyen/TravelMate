import asyncio
import httpx
import json
import sys

BASE_URL = "http://127.0.0.1:8000"

def safe_print(title: str, data: any):
    """
    Safely prints outputs to console to prevent Windows character mapping encoding crashes.
    """
    print(f"\n================ {title} ================")
    try:
        if isinstance(data, (dict, list)):
            serialized = json.dumps(data, ensure_ascii=True, indent=2)
            print(serialized)
        else:
            print(ascii(data))
    except Exception as e:
        print(f"[Error printing data]: {ascii(e)}")

async def test_recommend_places(client: httpx.AsyncClient):
    print("\n--- Running Test: POST /ai/recommend-places ---")
    payload = {
        "latitude": 16.0544,
        "longitude": 108.2022,
        "radius_km": 3.0,
        "category": "restaurant",
        "preferences": ["lucky", "cafe", "street food"]
    }
    try:
        resp = await client.post(f"{BASE_URL}/ai/recommend-places", json=payload, timeout=60.0)
        safe_print(f"POST /ai/recommend-places [Status {resp.status_code}]", resp.json() if resp.status_code == 200 else resp.text)
    except Exception as e:
        print("Exception in recommend-places test:", e)

async def test_generate_itinerary(client: httpx.AsyncClient):
    print("\n--- Running Test: POST /ai/generate-itinerary ---")
    payload = {
        "destination": "Đà Nẵng",
        "duration_days": 2,
        "budget": 2000000.0,
        "travel_style": "ngon rẻ, khám phá",
        "traveler_count": 2,
        "preferences": ["ẩm thực hải sản", "thích chụp ảnh check-in"]
    }
    try:
        resp = await client.post(f"{BASE_URL}/ai/generate-itinerary", json=payload, timeout=180.0)
        safe_print(f"POST /ai/generate-itinerary [Status {resp.status_code}]", resp.json() if resp.status_code == 200 else resp.text)
    except Exception as e:
        print("Exception in generate-itinerary test:", e)

async def test_optimize_route(client: httpx.AsyncClient):
    print("\n--- Running Test: POST /ai/optimize-route ---")
    payload = {
        "locations": [
            {"place_id": 101, "location_name": "Bán đảo Sơn Trà", "current_sequence": 1, "latitude": 16.0984, "longitude": 108.2721, "category": "attraction"},
            {"place_id": 102, "location_name": "Chùa Linh Ứng", "current_sequence": 2, "latitude": 16.1008, "longitude": 108.2778, "category": "attraction"},
            {"place_id": 104, "location_name": "Nhà hàng hải sản Bé Mặn", "current_sequence": 3, "latitude": 16.0825, "longitude": 108.2492, "category": "restaurant"},
            {"place_id": 103, "location_name": "Cầu Rồng", "current_sequence": 4, "latitude": 16.0612, "longitude": 108.2268, "category": "attraction"}
        ]
    }
    try:
        resp = await client.post(f"{BASE_URL}/ai/optimize-route", json=payload, timeout=60.0)
        safe_print(f"POST /ai/optimize-route [Status {resp.status_code}]", resp.json() if resp.status_code == 200 else resp.text)
    except Exception as e:
        print("Exception in optimize-route test:", e)

async def test_adjust_weather(client: httpx.AsyncClient):
    print("\n--- Running Test: POST /ai/adjust-weather ---")
    payload = {
        "weather_alert": "Ngày mai trời mưa to, có bão gió giật mạnh ở Đà Nẵng.",
        "budget_limit": 500000.0,
        "current_activities": [
            {
                "time": "08:00 - 11:30",
                "start_time": "08:00",
                "duration_minutes": 210,
                "place_name": "Bãi biển Mỹ Khê tắm biển và chơi thể thao cát",
                "category": "activity",
                "estimated_cost": 50000.0,
                "description": "Tắm biển buổi sáng và dạo chơi bãi cát Mỹ Khê."
            }
        ]
    }
    try:
        resp = await client.post(f"{BASE_URL}/ai/adjust-weather", json=payload, timeout=60.0)
        safe_print(f"POST /ai/adjust-weather [Status {resp.status_code}]", resp.json() if resp.status_code == 200 else resp.text)
    except Exception as e:
        print("Exception in adjust-weather test:", e)

async def test_chat_and_history(client: httpx.AsyncClient):
    session_id = "suite_test_session_111"
    print(f"\n--- Running Test: POST /ai/chat & GET /ai/chat/{{session_id}} for session '{session_id}' ---")
    
    # 1. Test POST chat message
    chat_payload = {
        "session_id": session_id,
        "message": "Tôi là khách du lịch Hội An, hãy gợi ý cho tôi 1 món ăn đặc sản."
    }
    try:
        post_resp = await client.post(f"{BASE_URL}/ai/chat", json=chat_payload, timeout=120.0)
        safe_print(f"POST /ai/chat [Status {post_resp.status_code}]", post_resp.json() if post_resp.status_code == 200 else post_resp.text)
        
        if post_resp.status_code == 200:
            # 2. Test GET chat history
            get_resp = await client.get(f"{BASE_URL}/ai/chat/{session_id}", timeout=20.0)
            safe_print(f"GET /ai/chat/{session_id} [Status {get_resp.status_code}]", get_resp.json() if get_resp.status_code == 200 else get_resp.text)
            
    except Exception as e:
        print("Exception in chat and history test:", e)

async def main():
    print(f"Starting test scenario suite against base API: {BASE_URL}")
    print("Ensure uvicorn is running, Geoapify API key is valid, and Ollama service is active.")
    
    async with httpx.AsyncClient() as client:
        # Run all test scenarios
        await test_recommend_places(client)
        await test_optimize_route(client)
        await test_adjust_weather(client)
        await test_chat_and_history(client)
        await test_generate_itinerary(client) # Run itinerary last as it takes the longest

    print("\nEndpoint test scenario suite finished!")

if __name__ == "__main__":
    asyncio.run(main())
