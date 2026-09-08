from fastapi import FastAPI
from app.core.config import settings
from app.features.chat.router import router as chat_router
from app.features.itinerary.router import router as itinerary_router
from app.features.places.router import router as places_router
from app.features.places.geoapify_router import router as geoapify_raw_router
from app.features.tips.router import router as tips_router
from app.features.packing.router import router as packing_router
from app.features.review.router import router as review_router


app = FastAPI(
    title="TravelMate AI Service (Cloud LLM)",
    version="2.0.0",
    description=(
        "Microservice AI sử dụng Groq + GPT-OSS-20B + Geoapify — Feature-Based Architecture.\n\n"
    )
)

# Register Feature-Based Routers
app.include_router(chat_router)
app.include_router(itinerary_router)
app.include_router(places_router)
app.include_router(geoapify_raw_router)
app.include_router(tips_router)
app.include_router(packing_router)
app.include_router(review_router)


@app.get("/")
def root():
    return {
        "status": "online",
        "model": settings.GROQ_MODEL,
        "version": "2.0.0",
        "message": "TravelMate Cloud LLM AI Service is ready!",
        "features": [
            "chat", "chat/stream",
            "generate-itinerary", "optimize-route", "adjust-weather",
            "recommend-places",
            "travel-tips",
            "packing-list",
            "trip-review",
            "geoapify/geocode", "geoapify/places", "geoapify/routing"
        ]
    }
