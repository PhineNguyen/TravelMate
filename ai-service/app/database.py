from sqlalchemy import create_engine, Column, Integer, String, Text
from sqlalchemy.orm import sessionmaker, declarative_base

# Tạo file database cục bộ tên là aichat.db
SQLALCHEMY_DATABASE_URL = "sqlite:///./aichat.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

# Định nghĩa cấu trúc bảng lưu lịch sử chat
class ChatMessage(Base):
    __tablename__ = "chat_messages"

    id = Column(Integer, primary_key=True, index=True)
    session_id = Column(String, index=True) # ID của chuyến đi hoặc user để gom nhóm tin nhắn
    role = Column(String)                   # 'user' hoặc 'model' (quy ước của Gemini)
    content = Column(Text)                  # Nội dung tin nhắn