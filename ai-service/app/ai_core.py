import google.generativeai as genai
from app.config import Config
from app.schemas import TripRequest, FinalTripPlanSchema
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