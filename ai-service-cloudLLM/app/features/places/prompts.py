import json

def get_recommend_prompt(simplified_places: list, user_preferences: list, category: str) -> str:
    return f"""
    Bạn là trợ lý du lịch AI thông minh.
    Danh sách địa điểm thực tế tìm được (định dạng: ID và Tên):
    {json.dumps(simplified_places, ensure_ascii=False)}
    
    Sở thích người dùng: {', '.join(user_preferences) if user_preferences else 'Không có'}
    Loại địa điểm: {category}

    Hãy chọn ra tối đa 5 địa điểm phù hợp nhất với sở thích của người dùng từ danh sách trên.
    Với mỗi địa điểm được chọn, đưa ra 1 lý do ngắn gọn (1-2 câu).
    
    Trả về ĐÚNG cấu trúc mảng JSON chứa các đối tượng có thuộc tính "id" và "reason" như sau:
    [
      {{
        "id": 0,
        "reason": "Lý do gợi ý địa điểm này..."
      }}
    ]
    """
