import asyncio
import time
import httpx
from typing import List, Dict, Any

BASE_URL = "http://localhost:8001"

results = []

def record_result(method: str, test_id: str, description: str, status: str, details: str, duration: float):
    results.append({
        "method": method,
        "test_id": test_id,
        "description": description,
        "status": status,
        "details": details,
        "duration": duration
    })
    symbol = "[PASS]" if status == "PASS" else "[FAIL]"
    print(f"{symbol} {test_id} ({method}): {description} [{duration:.2f}s]")
    if status == "FAIL" or "error" in details.lower():
        print(f"       -> Details: {details}")


# ==============================================================================
# 1. EQUIVALENCE PARTITIONING (EP) - PHÂN HOẠCH TƯƠNG ĐƯƠNG
# ==============================================================================
async def test_equivalence_partitioning(client: httpx.AsyncClient):
    print("\n" + "="*80)
    print(" 1. EQUIVALENCE PARTITIONING (EP) - PHÂN HOẠCH TƯƠNG ĐƯƠNG")
    print("="*80)

    ep_test_cases = [
        # Valid Partitions
        {
            "id": "EP-01",
            "desc": "Valid Partition: Food & Drink (Món ăn, ẩm thực)",
            "payload": {
                "session_id": "ep_food_session",
                "message": "Đà Lạt có những món đặc sản nào ngon và quán nào nổi tiếng?",
                "destination": "Đà Lạt"
            },
            "expected_intent": "food",
            "validate_structured": lambda data: data is not None and "items" in data and len(data["items"]) > 0
        },
        {
            "id": "EP-02",
            "desc": "Valid Partition: Weather & Climate (Thời tiết)",
            "payload": {
                "session_id": "ep_weather_session",
                "message": "Dự báo thời tiết Sapa tuần này thế nào, có mưa hay rét buốt không?",
                "destination": "Sapa"
            },
            "expected_intent": "weather",
            "validate_structured": lambda data: data is None
        },
        {
            "id": "EP-03",
            "desc": "Valid Partition: Budget & Expenses (Ngân sách)",
            "payload": {
                "session_id": "ep_budget_session",
                "message": "Dự trù chi phí đi Phú Quốc 3 ngày 2 đêm cho 2 người khoảng bao nhiêu tiền?",
                "destination": "Phú Quốc"
            },
            "expected_intent": "budget",
            "validate_structured": lambda data: data is not None and "budget_items" in data and len(data["budget_items"]) > 0
        },
        {
            "id": "EP-04",
            "desc": "Valid Partition: Transportation (Phương tiện đi lại)",
            "payload": {
                "session_id": "ep_transport_session",
                "message": "Từ sân bay Cam Ranh về trung tâm Nha Trang nên đi bằng xe bus hay taxi?",
                "destination": "Nha Trang"
            },
            "expected_intent": "transportation",
            "validate_structured": lambda data: data is None
        },
        {
            "id": "EP-05",
            "desc": "Valid Partition: Accommodation (Nơi ở / Khách sạn)",
            "payload": {
                "session_id": "ep_hotel_session",
                "message": "Gợi ý cho tôi một số homestay view đẹp, giá hợp lý ở Đà Lạt",
                "destination": "Đà Lạt"
            },
            "expected_intent": ["accommodation", "place_recommendation"],
            "validate_structured": lambda data: data is not None and "places" in data and len(data["places"]) > 0
        },
        {
            "id": "EP-06",
            "desc": "Valid Partition: Place Recommendation (Điểm tham quan)",
            "payload": {
                "session_id": "ep_place_session",
                "message": "Ở Hội An có những địa điểm check-in chụp ảnh nào đẹp nhất?",
                "destination": "Hội An"
            },
            "expected_intent": "place_recommendation",
            "validate_structured": lambda data: data is not None and "places" in data and len(data["places"]) > 0
        },
        {
            "id": "EP-07",
            "desc": "Valid Partition: Trip Preparation (Chuẩn bị hành lý)",
            "payload": {
                "session_id": "ep_packing_session",
                "message": "Đi leo núi Fansipan thì cần chuẩn bị những trang phục và đồ dùng y tế gì?",
                "destination": "Fansipan"
            },
            "expected_intent": "trip_preparation",
            "validate_structured": lambda data: data is None
        },
        {
            "id": "EP-08",
            "desc": "Valid Partition: General Travel Inquiry (Hỏi chung)",
            "payload": {
                "session_id": "ep_general_session",
                "message": "Lần đầu đi du lịch tự túc thì nên lưu ý những điều gì để an toàn?",
            },
            "expected_intent": "general_travel",
            "validate_structured": lambda data: data is None
        },
        # Invalid / Out-of-Scope Partitions
        {
            "id": "EP-09",
            "desc": "Invalid Partition: Out-of-scope Coding Query (Lập trình)",
            "payload": {
                "session_id": "ep_oos_session",
                "message": "Hãy viết code Python giải phương trình bậc hai ax2 + bx + c = 0",
            },
            "expected_intent": "out_of_scope",
            "validate_structured": lambda data: data is None
        },
        {
            "id": "EP-10",
            "desc": "Invalid Partition: Out-of-scope Politics/Math (Ngoài lề)",
            "payload": {
                "session_id": "ep_oos2_session",
                "message": "Ai là tổng thống đời thứ 16 của Hợp chủng quốc Hoa Kỳ?",
            },
            "expected_intent": "out_of_scope",
            "validate_structured": lambda data: data is None
        },
        {
            "id": "EP-11",
            "desc": "Invalid Partition: Gibberish Characters (Ký tự vô nghĩa)",
            "payload": {
                "session_id": "ep_gibberish_session",
                "message": "asdfghjkl qwerty uiop zxcvbnm 123456",
            },
            "expected_intent": ["out_of_scope", "general_travel"],
            "validate_structured": lambda data: data is None
        },
    ]

    for tc in ep_test_cases:
        start_t = time.time()
        try:
            resp = await client.post(f"{BASE_URL}/ai/chat", json=tc["payload"], timeout=30.0)
            elapsed = time.time() - start_t
            if resp.status_code == 200:
                body = resp.json()
                act_intent = body.get("intent")
                reply = body.get("reply", "")
                struct = body.get("structured_data")

                expected = tc["expected_intent"]
                intent_match = (act_intent in expected) if isinstance(expected, list) else (act_intent == expected)
                struct_valid = tc["validate_structured"](struct)
                reply_valid = len(reply.strip()) > 10

                if intent_match and struct_valid and reply_valid:
                    record_result("EP", tc["id"], tc["desc"], "PASS", f"Intent={act_intent}, ReplyLen={len(reply)}", elapsed)
                else:
                    details = f"IntentMatch={intent_match} (Got: '{act_intent}', Exp: {expected}), StructValid={struct_valid}"
                    record_result("EP", tc["id"], tc["desc"], "FAIL", details, elapsed)
            else:
                record_result("EP", tc["id"], tc["desc"], "FAIL", f"HTTP Status: {resp.status_code}", elapsed)
        except Exception as e:
            record_result("EP", tc["id"], tc["desc"], "FAIL", f"Exception: {str(e)}", time.time() - start_t)


# ==============================================================================
# 2. BOUNDARY VALUE ANALYSIS (BVA) - PHÂN TÍCH GIÁ TRỊ BIÊN
# ==============================================================================
async def test_boundary_value_analysis(client: httpx.AsyncClient):
    print("\n" + "="*80)
    print(" 2. BOUNDARY VALUE ANALYSIS (BVA) - PHÂN TÍCH GIÁ TRỊ BIÊN")
    print("="*80)

    bva_test_cases = [
        # Biên độ dài message
        {
            "id": "BVA-01",
            "desc": "Min-1 Boundary: Message rỗng (0 ký tự)",
            "payload": {
                "session_id": "bva_msg_empty",
                "message": ""
            },
            "expect_error": False,  # Should handle gracefully without crash
            "validator": lambda resp: resp.status_code in [200, 400, 422]
        },
        {
            "id": "BVA-02",
            "desc": "Min Boundary: Message chỉ có 1 ký tự ('?')",
            "payload": {
                "session_id": "bva_msg_1char",
                "message": "?"
            },
            "expect_error": False,
            "validator": lambda resp: resp.status_code == 200 and len(resp.json().get("reply", "")) > 0
        },
        {
            "id": "BVA-03",
            "desc": "Min+1 Boundary: Message câu hỏi cực ngắn (2 ký tự: 'Đi')",
            "payload": {
                "session_id": "bva_msg_2char",
                "message": "Đi"
            },
            "expect_error": False,
            "validator": lambda resp: resp.status_code == 200
        },
        {
            "id": "BVA-04",
            "desc": "Nominal Boundary: Message trung bình (~100 ký tự)",
            "payload": {
                "session_id": "bva_msg_nominal",
                "message": "Tôi dự định đi Đà Lạt cùng gia đình có 2 con nhỏ, muốn tìm khách sạn có khu vui chơi và gần trung tâm."
            },
            "expect_error": False,
            "validator": lambda resp: resp.status_code == 200 and len(resp.json().get("reply", "")) > 20
        },
        {
            "id": "BVA-05",
            "desc": "Max Boundary: Message dài lớn (~2000 ký tự mô tả chi tiết chuyến đi)",
            "payload": {
                "session_id": "bva_msg_large",
                "message": "Tôi và nhóm bạn 6 người muốn đi phượt dọc bờ biển miền Trung từ Đà Nẵng qua Quy Nhơn, Tuy Hòa, Nha Trang đến Phan Thiết trong 10 ngày. " * 15
            },
            "expect_error": False,
            "validator": lambda resp: resp.status_code == 200 and len(resp.json().get("reply", "")) > 50
        },
        # Biên session_id
        {
            "id": "BVA-06",
            "desc": "Min Boundary: session_id ngắn 1 ký tự ('a')",
            "payload": {
                "session_id": "a",
                "message": "Thời tiết Huế hôm nay thế nào?"
            },
            "expect_error": False,
            "validator": lambda resp: resp.status_code == 200
        },
        {
            "id": "BVA-07",
            "desc": "Max Boundary: session_id dài đúng 255 ký tự (VARCHAR 255)",
            "payload": {
                "session_id": "s" * 255,
                "message": "Chào bạn, tư vấn du lịch giúp tôi"
            },
            "expect_error": False,
            "validator": lambda resp: resp.status_code == 200
        },
        # Biên tham số tùy chọn (destination, preferences)
        {
            "id": "BVA-08",
            "desc": "Optional Boundary: destination = None, preferences = None",
            "payload": {
                "session_id": "bva_none_params",
                "message": "Ăn gì ngon ở Hà Nội?",
                "destination": None,
                "preferences": None
            },
            "expect_error": False,
            "validator": lambda resp: resp.status_code == 200 and resp.json().get("intent") == "food"
        },
        {
            "id": "BVA-09",
            "desc": "Optional Boundary: preferences là mảng list rỗng []",
            "payload": {
                "session_id": "bva_empty_pref_list",
                "message": "Thời tiết Vũng Tàu cuối tuần?",
                "preferences": []
            },
            "expect_error": False,
            "validator": lambda resp: resp.status_code == 200
        },
        {
            "id": "BVA-10",
            "desc": "Optional Boundary: preferences là danh sách nhiều sở thích phức tạp",
            "payload": {
                "session_id": "bva_complex_pref",
                "message": "Gợi ý điểm đến ở Đà Nẵng",
                "preferences": ["yêu thiên nhiên", "thích chụp ảnh chill", "ăn chay", "thích đi bộ", "ngân sách tiết kiệm"]
            },
            "expect_error": False,
            "validator": lambda resp: resp.status_code == 200
        }
    ]

    for tc in bva_test_cases:
        start_t = time.time()
        try:
            resp = await client.post(f"{BASE_URL}/ai/chat", json=tc["payload"], timeout=40.0)
            elapsed = time.time() - start_t
            if tc["validator"](resp):
                record_result("BVA", tc["id"], tc["desc"], "PASS", f"HTTP {resp.status_code}", elapsed)
            else:
                record_result("BVA", tc["id"], tc["desc"], "FAIL", f"HTTP {resp.status_code}: {resp.text[:100]}", elapsed)
        except Exception as e:
            record_result("BVA", tc["id"], tc["desc"], "FAIL", f"Exception: {str(e)}", time.time() - start_t)


# ==============================================================================
# 3. DECISION TABLE TESTING (DTT) - KIỂM THỬ BẢNG QUYẾT ĐỊNH
# ==============================================================================
async def test_decision_table(client: httpx.AsyncClient):
    print("\n" + "="*80)
    print(" 3. DECISION TABLE TESTING (DTT) - KIỂM THỬ BẢNG QUYẾT ĐỊNH")
    print("="*80)

    # Decision Table Rules:
    # Rule 1: Intent == 'food'                -> Reply != '', Intent == 'food', Struct has 'items' list
    # Rule 2: Intent == 'budget'              -> Reply != '', Intent == 'budget', Struct has 'budget_items' list
    # Rule 3: Intent == 'place_recommendation'-> Reply != '', Intent == 'place_rec', Struct has 'places' list
    # Rule 4: Intent == 'accommodation'       -> Reply != '', Intent in [place, accom], Struct has 'places' list
    # Rule 5: Intent == 'weather'             -> Reply != '', Intent == 'weather', Struct is None
    # Rule 6: Intent == 'out_of_scope'        -> Reply contains polite refusal, Intent == 'out_of_scope', Struct is None
    # Rule 7: DB History Persistence          -> GET /ai/chat/{session} returns all messages chronological
    # Rule 8: DB History Clear                -> DELETE /ai/chat/{session} removes all messages

    dtt_cases = [
        {
            "id": "DT-01",
            "rule": "Rule 1 (Food Rule)",
            "message": "Bánh mì Hội An có quán nào ngon nhất?",
            "check": lambda res: res["intent"] == "food" and res["structured_data"] is not None and "items" in res["structured_data"]
        },
        {
            "id": "DT-02",
            "rule": "Rule 2 (Budget Rule)",
            "message": "Đi Hà Giang 4 ngày 3 đêm hết bao nhiêu tiền?",
            "check": lambda res: res["intent"] == "budget" and res["structured_data"] is not None and "budget_items" in res["structured_data"]
        },
        {
            "id": "DT-03",
            "rule": "Rule 3 (Place Recommendation Rule)",
            "message": "Gợi ý các danh lam thắng cảnh ở Ninh Bình",
            "check": lambda res: res["intent"] == "place_recommendation" and res["structured_data"] is not None and "places" in res["structured_data"]
        },
        {
            "id": "DT-04",
            "rule": "Rule 4 (Weather Rule - No Structured Data)",
            "message": "Nhiệt độ hiện tại ở Mộc Châu có lạnh không?",
            "check": lambda res: res["intent"] == "weather" and res["structured_data"] is None
        },
        {
            "id": "DT-05",
            "rule": "Rule 5 (Out of Scope Rule - Refusal & No Structured Data)",
            "message": "Làm thế nào để kiếm tiền online qua drop-shipping?",
            "check": lambda res: res["intent"] == "out_of_scope" and res["structured_data"] is None and "du lịch" in res["reply"].lower()
        },
    ]

    for tc in dtt_cases:
        start_t = time.time()
        try:
            resp = await client.post(f"{BASE_URL}/ai/chat", json={
                "session_id": f"dtt_{tc['id']}",
                "message": tc["message"]
            }, timeout=30.0)
            elapsed = time.time() - start_t
            if resp.status_code == 200:
                data = resp.json()
                if tc["check"](data):
                    record_result("DTT", tc["id"], f"{tc['rule']}: Verified outputs", "PASS", f"Intent={data['intent']}", elapsed)
                else:
                    record_result("DTT", tc["id"], f"{tc['rule']}: Verified outputs", "FAIL", f"Output didn't match rule: {data}", elapsed)
            else:
                record_result("DTT", tc["id"], f"{tc['rule']}", "FAIL", f"HTTP {resp.status_code}", elapsed)
        except Exception as e:
            record_result("DTT", tc["id"], f"{tc['rule']}", "FAIL", f"Exception: {str(e)}", time.time() - start_t)
        await asyncio.sleep(0.4)

    # Rule 7 & 8: State Transition (History Save and Delete)
    session_id = f"dtt_crud_session_{int(time.time())}"
    start_t = time.time()
    try:
        # 1. Send message
        await client.post(f"{BASE_URL}/ai/chat", json={
            "session_id": session_id,
            "message": "Xin chào, tôi là khách du lịch từ Sài Gòn"
        }, timeout=30.0)

        # 2. Get history (Rule 7)
        get_resp = await client.get(f"{BASE_URL}/ai/chat/{session_id}", timeout=10.0)
        history = get_resp.json().get("messages", [])
        has_user = any(m["role"] == "user" for m in history)
        has_assistant = any(m["role"] == "assistant" for m in history)

        if len(history) >= 2 and has_user and has_assistant:
            record_result("DTT", "DT-06", "Rule 7 (Persistence): GET history returns user & assistant messages", "PASS", f"Found {len(history)} messages", time.time() - start_t)
        else:
            record_result("DTT", "DT-06", "Rule 7 (Persistence): GET history returns user & assistant messages", "FAIL", f"Messages: {history}", time.time() - start_t)

        # 3. Clear history (Rule 8)
        start_del_t = time.time()
        del_resp = await client.delete(f"{BASE_URL}/ai/chat/{session_id}", timeout=10.0)
        verify_get = await client.get(f"{BASE_URL}/ai/chat/{session_id}", timeout=10.0)
        clean_history = verify_get.json().get("messages", [])

        if del_resp.status_code == 200 and len(clean_history) == 0:
            record_result("DTT", "DT-07", "Rule 8 (Clearance): DELETE history removes all session messages", "PASS", "Session cleaned completely", time.time() - start_del_t)
        else:
            record_result("DTT", "DT-07", "Rule 8 (Clearance): DELETE history removes all session messages", "FAIL", f"Remaining messages: {len(clean_history)}", time.time() - start_del_t)

    except Exception as e:
        record_result("DTT", "DT-06/07", "History CRUD", "FAIL", f"Exception: {str(e)}", time.time() - start_t)


# ==============================================================================
# MAIN TEST RUNNER
# ==============================================================================
async def main():
    import json
    print("="*80)
    print(" TRAVELMATE AI SERVICE - COMPREHENSIVE TEST SUITE")
    print(f" Target URL: {BASE_URL}")
    print("="*80)

    async with httpx.AsyncClient() as client:
        await test_equivalence_partitioning(client)
        await test_boundary_value_analysis(client)
        await test_decision_table(client)

    # Print Summary Table
    print("\n" + "="*80)
    print(" SUMMARY TEST RESULTS")
    print("="*80)
    total = len(results)
    passed = sum(1 for r in results if r["status"] == "PASS")
    failed = total - passed

    print(f"Total Tests Executed: {total}")
    print(f"Passed: {passed} ({passed/total*100:.1f}%)")
    print(f"Failed: {failed} ({failed/total*100:.1f}%)")
    print("="*80)

    with open("test_results.json", "w", encoding="utf-8") as f:
        json.dump(results, f, ensure_ascii=False, indent=2)
    print("Test report saved to test_results.json")

if __name__ == "__main__":
    asyncio.run(main())
