import google.generativeai as genai
from sqlalchemy.orm import Session
from app.config import Config
from app.database import ChatMessage
from app.schemas import (
    TripRequest, FinalTripPlanSchema, 
    PlaceRecommendationRequest, PlaceRecommendationResponse,
    RouteOptimizationRequest, OptimizedRouteResponse,
    WeatherAdjustmentRequest, WeatherAdjustmentResponse,
    ChatRequest
)
from app.places_service import GooglePlacesService

import json

class AICoreService:
    def __init__(self):
        # Kiểm tra cấu hình key trước khi khởi tạo
        Config.validate_config()
        genai.configure(api_key=Config.GEMINI_API_KEY)
        # Sử dụng mô hình flash tối ưu cho cấu trúc JSON và tốc độ phản hồi
        self.model = genai.GenerativeModel('gemini-2.5-flash')
        self.places_service = GooglePlacesService()
    async def generate_itinerary(self, data: TripRequest) -> dict:
        # 1. Lấy dữ liệu thật từ Google Maps
        search_query = f"Điểm tham quan nổi bật và nhà hàng tại {data.destination}"
        real_places_data = self.places_service.search_places(search_query)

        system_prompt = f"""
        Bạn là chuyên gia lập kế hoạch du lịch thông minh toàn năng (AI Travel Companion) của ứng dụng TravelMate.
        Hãy thiết kế một lịch trình du lịch chi tiết dựa trên các tham số sau:
        - Điểm đến: {data.destination}
        - Số ngày đi: {data.total_days} ngày
        - Ngân sách tối đa: {data.budget} VND
        - Phong cách du lịch: {data.travel_style}

        [DỮ LIỆU ĐỊA ĐIỂM THỰC TẾ]:
        {real_places_data if real_places_data else 'Sử dụng kiến thức nội tại.'}

        Quy tắc nghiệp vụ bắt buộc tuân thủ:
        1. Ưu tiên sử dụng các địa điểm có trong [DỮ LIỆU ĐỊA ĐIỂM THỰC TẾ].
        2. Nếu chọn địa điểm từ dữ liệu thật, phải sao chép chính xác "Link bản đồ" vào trường 'google_maps_url'.
        3. Tối ưu hóa tuyến đường: Sắp xếp các địa điểm gần nhau vào cùng một ngày.
        4. Tổng chi phí ước tính ('estimated_total_cost') KHÔNG vượt quá {data.budget} VND.
        """

        generation_config = {
            "response_mime_type": "application/json",
            "response_schema": FinalTripPlanSchema, 
            "temperature": 0.2 
        }

        response = self.model.generate_content(
            system_prompt,
            generation_config=generation_config
        )
        return json.loads(response.text)
    
    async def recommend_places(self, data: PlaceRecommendationRequest) -> dict:
        # Lấy dữ liệu thật từ Google Maps
        search_query = f"{data.place_type} tại {data.destination}"
        real_places_data = self.places_service.search_places(search_query)

        system_prompt = f"""
        Bạn là thổ địa du lịch tại {data.destination}. Người dùng tìm kiếm '{data.place_type}' 
        trong bán kính {data.radius_km}km. Sở thích: {data.preferences if data.preferences else 'Không có'}.
        
        [DỮ LIỆU ĐỊA ĐIỂM THỰC TẾ]:
        {real_places_data if real_places_data else 'Sử dụng kiến thức nội tại.'}

        Nhiệm vụ: Gợi ý danh sách địa điểm phù hợp nhất, sao chép "Link bản đồ" vào trường 'google_maps_url'.
        """
        response = self.model.generate_content(
            system_prompt,
            generation_config={
                "response_mime_type": "application/json",
                "response_schema": PlaceRecommendationResponse,
                "temperature": 0.4
            }
        )
        return json.loads(response.text)

    async def optimize_route(self, data: RouteOptimizationRequest) -> dict:
        places_str = ", ".join([f"{item.location_name} (Thứ tự cũ: {item.current_sequence})" for item in data.locations])
        system_prompt = f"""
        Hãy đóng vai trò chuyên gia bản đồ. Người dùng có danh sách các địa điểm cần đi như sau: {places_str}.
        Dựa trên khoảng cách địa lý thực tế, hãy sắp xếp lại trường 'optimized_sequence' (từ 1, 2, 3...) 
        sao cho lộ trình di chuyển là hợp lý nhất, đi theo cụm gần nhau, tránh chạy vòng vèo tốn thời gian.
        """
        response = self.model.generate_content(
            system_prompt,
            generation_config={
                "response_mime_type": "application/json",
                "response_schema": OptimizedRouteResponse,
                "temperature": 0.1 # Nhiệt độ rất thấp để giữ tính logic toán học, địa lý
            }
        )
        return json.loads(response.text)

    async def adjust_weather(self, data: WeatherAdjustmentRequest) -> dict:
        activities_str = json.dumps([act.dict() for act in data.current_activities], ensure_ascii=False)
        system_prompt = f"""
        Thời tiết tại điểm đến đang có cảnh báo: '{data.weather_alert}'.
        Ngân sách tối đa cho phép thay đổi: {data.budget_limit} VND.
        Đây là lịch trình hiện tại của người dùng: {activities_str}
        
        Nhiệm vụ:
        1. Giữ nguyên các hoạt động không bị ảnh hưởng bởi thời tiết (ví dụ: ăn uống trong nhà).
        2. Loại bỏ các hoạt động ngoài trời nguy hiểm/bất tiện và thay thế bằng các địa điểm trong nhà 
        (bảo tàng, xưởng thủ công, cà phê...) có mức chi phí tương đương.
        3. Cung cấp lý do giải thích sự thay đổi ở trường 'adjustment_reason'.
        """
        response = self.model.generate_content(
            system_prompt,
            generation_config={
                "response_mime_type": "application/json",
                "response_schema": WeatherAdjustmentResponse,
                "temperature": 0.2
            }
        )
        return json.loads(response.text)
    
    async def chat_with_ai(self, data: ChatRequest, db: Session) -> dict:
        # 1. Truy xuất lịch sử trò chuyện từ Database dựa trên session_id
        history_records = db.query(ChatMessage).filter(ChatMessage.session_id == data.session_id).order_by(ChatMessage.id).all()
        
        formatted_history = []
        for record in history_records:
            formatted_history.append({
                "role": record.role,
                "parts": [record.content]
            })

        # 2. Khởi tạo phiên trò chuyện của Gemini kèm theo bộ nhớ cũ
        chat_session = self.model.start_chat(history=formatted_history)

        # 3. Gửi tin nhắn mới và nhận phản hồi
        response = chat_session.send_message(data.message)
        ai_reply = response.text

        # 4. Lưu tin nhắn của Người dùng vào Database
        user_msg = ChatMessage(session_id=data.session_id, role="user", content=data.message)
        db.add(user_msg)

        # 5. Lưu câu trả lời của AI vào Database
        ai_msg = ChatMessage(session_id=data.session_id, role="model", content=ai_reply)
        db.add(ai_msg)
        
        # Xác nhận lưu thay đổi
        db.commit()

        return {"reply": ai_reply}