import os
from dotenv import load_dotenv
from google import genai

# Tải cấu hình từ file .env
load_dotenv()

api_key = os.getenv("GEMINI_API_KEY")
print(f"API Key loaded from .env: '{api_key}'")

if not api_key or api_key.startswith("your_"):
    print("Error: GEMINI_API_KEY chưa được thiết lập chính xác trong file .env")
    exit(1)

# Khởi tạo Client bằng SDK mới
client = genai.Client(api_key=api_key)

try:
    print("Đang gọi thử Gemini API...")
    # Dùng model gemini-2.0-flash
    response = client.models.generate_content(
        model='gemini-2.0-flash-lite',
        contents="Hello! Say 'Gemini API is working successfully!' in Vietnamese."
    )
    print("\n--- Phản hồi từ Gemini ---")
    print(response.text)
    print("---------------------------")
    print("KẾT QUẢ: Kết nối thành công! API Key của bạn hoạt động bình thường.")
except Exception as e:
    print("\n--- Chi tiết lỗi xảy ra ---")
    print(str(e))
    print("--------------------------")
    print("KẾT QUẢ: Thất bại!")