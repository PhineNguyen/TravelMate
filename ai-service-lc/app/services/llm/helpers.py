def clean_json_response(raw_text: str) -> str:
    """
    Cleans markdown wrappers or backticks often returned by LLMs
    to extract a clean JSON string.
    """
    raw_text = raw_text.strip()
    if raw_text.startswith("```"):
        lines = raw_text.splitlines()
        if lines[0].startswith("```"):
            lines = lines[1:]
        if lines and lines[-1].startswith("```"):
            lines = lines[:-1]
        raw_text = "\n".join(lines).strip()
    return raw_text

def try_repair_json(json_str: str) -> str:
    """
    Attempts to repair incomplete or truncated JSON strings by closing
    any unclosed quotes, braces, or brackets, and removing trailing commas.
    """
    json_str = json_str.strip()
    if not json_str:
        return json_str

    # Clean trailing characters and commas
    while True:
        original_length = len(json_str)
        json_str = json_str.strip()
        if json_str.endswith(","):
            json_str = json_str[:-1]
        if len(json_str) == original_length:
            break

    open_brackets = []
    in_string = False
    escape = False

    for char in json_str:
        if escape:
            escape = False
            continue
        if char == '\\':
            escape = True
            continue
        if char == '"':
            in_string = not in_string
            continue
        if in_string:
            continue
        if char in ['{', '[']:
            open_brackets.append(char)
        elif char in ['}', ']']:
            if open_brackets:
                open_brackets.pop()

    if in_string:
        json_str += '"'

    for bracket in reversed(open_brackets):
        while True:
            json_str = json_str.strip()
            if json_str.endswith(","):
                json_str = json_str[:-1]
            else:
                break
        if bracket == '{':
            json_str += '}'
        elif bracket == '[':
            json_str += ']'

    return json_str

def check_is_indoor(categories: list) -> bool:
    if not categories:
        return False
    indoor_keywords = {
        "restaurant", "cafe", "fast_food", "bar", "food_court", "pub",
        "hotel", "hostel", "motel", "guest_house", "apartment", "chalet",
        "museum", "cinema", "theater", "mall", "shop", "supermarket",
        "place_of_worship", "church", "temple", "pagoda", "cathedral",
        "art_gallery", "library", "exhibition_centre"
    }
    outdoor_keywords = {
        "beach", "park", "garden", "nature_reserve", "forest", "mountain",
        "viewpoint", "waterfall", "lake", "river", "swimming_pool", "playground",
        "zoo", "theme_park", "amusement_park", "stadium"
    }
    is_indoor_match = False
    is_outdoor_match = False
    for cat in categories:
        cat_lower = cat.lower()
        if any(kw in cat_lower for kw in indoor_keywords):
            is_indoor_match = True
        if any(kw in cat_lower for kw in outdoor_keywords):
            is_outdoor_match = True
            
    if is_indoor_match and not is_outdoor_match:
        return True
    if is_outdoor_match:
        return False
    return False
