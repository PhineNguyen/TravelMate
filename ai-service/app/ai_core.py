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
import json

class AICoreService:
    def __init__(self):
        # Kiểm tra cấu hình key trước khi khởi tạo
        Config.validate_config()
        genai.configure(api_key=Config.GEMINI_API_KEY)
        # Sử dụng mô hình flash tối ưu cho cấu trúc JSON và tốc độ phản hồi
        self.model = genai.GenerativeModel('gemini-2.5-flash')
    async def generate_itinerary(self, data: TripRequest) -> dict:
        """
        Gửi yêu cầu sang Google Gemini API và nhận về cấu trúc lịch trình dạng JSON thuần
        """
        # Cấu hình Prompt hệ thống lồng các quy tắc nghiệp vụ (Business Rules) vào
        system_prompt = f"""
        Bạn là chuyên gia lập kế hoạch du lịch thông minh toàn năng (AI Travel Companion) của ứng dụng TravelMate.
        Hãy thiết kế một lịch trình du lịch chi tiết dựa trên các tham số sau:
        - Điểm đến: {data.destination}
        - Số ngày đi: {data.total_days} ngày
        - Ngân sách tối đa: {data.budget} VND
        - Phong cách du lịch: {data.travel_style}

        Quy tắc nghiệp vụ bắt buộc tuân thủ:
        1. Tối ưu hóa tuyến đường (FR-TRIP-06): Hãy sắp xếp thứ tự các địa điểm (trường 'sequence') trong cùng một ngày theo cụm địa lý gần nhau để giảm thiểu quãng đường di chuyển của người dùng.
        2. Kiểm soát ngân sách (BR-BUDGET-02): Tổng chi phí ước tính (trường 'estimated_total_cost') là tổng cộng dồn chi phí của tất cả các hoạt động, ăn uống, trú ngụ. Con số này TUYỆT ĐỐI không được vượt quá số ngân sách ({data.budget} VND) mà người dùng cung cấp.
        3. Phân loại rõ ràng: Mọi địa điểm được gợi ý tại trường 'activity_type' phải thuộc một trong các nhóm: 'Attraction', 'Restaurant', 'Accommodation', 'Activity'.
        """

        # Kích hoạt tính năng Structured Outputs của Gemini
        generation_config = {
            "response_mime_type": "application/json",
            "response_schema": FinalTripPlanSchema, # Ép kiểu dữ liệu đầu ra trùng khớp với Pydantic
            "temperature": 0.2 # Giữ nhiệt độ thấp để AI tư duy logic, không sáng tác linh tinh
        }

        # Thực hiện cuộc gọi API sang Google
        response = self.model.generate_content(
            system_prompt,
            generation_config=generation_config
        )

        # Chuyển chuỗi văn bản JSON từ AI thành đối tượng Dictionary trong Python
        return json.loads(response.text)
    
    async def recommend_places(self, data: PlaceRecommendationRequest) -> dict:
        system_prompt = f"""
        Bạn là thổ địa du lịch tại {data.destination}. Người dùng đang tìm kiếm các địa điểm thuộc loại '{data.place_type}' 
        trong bán kính {data.radius_km}km. 
        Sở thích đặc biệt: {data.preferences if data.preferences else 'Không có'}.
        Hãy gợi ý danh sách các địa điểm phù hợp nhất, kèm chi phí ước tính và mô tả ngắn gọn.
        """
        response = self.model.generate_content(
            system_prompt,
            generation_config={
                "response_mime_type": "application/json",
                "response_schema": PlaceRecommendationResponse,
                "temperature": 0.4 # Nhiệt độ cao hơn một chút để đa dạng gợi ý
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