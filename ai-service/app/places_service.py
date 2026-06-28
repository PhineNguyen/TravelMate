import requests
from app.config import Config

class GooglePlacesService:
    def __init__(self):
        self.api_key = Config.GOOGLE_MAPS_API_KEY

    def search_places(self, query: str) -> str:
        """Tìm kiếm địa điểm thực tế trên Google Maps."""
        if not self.api_key:
            return ""

        url = "https://places.googleapis.com/v1/places:searchText"
        headers = {
            "Content-Type": "application/json",
            "X-Goog-Api-Key": self.api_key,
            "X-Goog-FieldMask": "places.displayName,places.formattedAddress,places.rating,places.userRatingCount,places.id"
        }
        data = {
            "textQuery": query,
            "languageCode": "vi"
        }
        
        try:
            response = requests.post(url, headers=headers, json=data)
            response.raise_for_status()
            places_data = response.json().get('places', [])
            return self._format_places_for_ai(places_data)
        except Exception as e:
            print(f"Lỗi khi gọi Google Places API: {e}")
            return ""

    def _format_places_for_ai(self, places: list) -> str:
        """Định dạng dữ liệu Ký hiệu Đối tượng JavaScript (JavaScript Object Notation - JSON) thô thành chuỗi văn bản cho AI đọc."""
        result_text = ""
        for p in places[:10]:
            name = p.get('displayName', {}).get('text', 'Không rõ tên')
            address = p.get('formattedAddress', 'Không rõ địa chỉ')
            rating = p.get('rating', 0)
            reviews = p.get('userRatingCount', 0)
            place_id = p.get('id', '')
            
            maps_url = f"https://www.google.com/maps/place/?q=place_id:{place_id}"
            
            result_text += f"- Tên: {name} (Đánh giá: {rating} sao / {reviews} nhận xét)\n"
            result_text += f"  Địa chỉ: {address}\n"
            result_text += f"  Link bản đồ: {maps_url}\n\n"
            
        return result_text