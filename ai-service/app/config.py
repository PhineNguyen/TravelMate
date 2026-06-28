import os
from dotenv import load_dotenv

# Tự động tìm và nạp các biến môi trường từ file .env ở thư mục gốc
load_dotenv()

class Config:
    GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
    GOOGLE_MAPS_API_KEY = os.getenv("GOOGLE_MAPS_API_KEY")
    
    @classmethod
    def validate_config(cls):
        """Kiểm tra xem API Key đã được cấu hình hay chưa"""
        if not cls.GEMINI_API_KEY:
            raise ValueError("LỖI: Chưa cấu hình GEMINI_API_KEY trong file .env")
        if not cls.GOOGLE_MAPS_API_KEY:
            print("CẢNH BÁO: Chưa cấu hình GOOGLE_MAPS_API_KEY, AI sẽ dùng kiến thức nội tại.")