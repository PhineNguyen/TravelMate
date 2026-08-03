from fastapi import FastAPI
from app.core.config import settings
from app.features.chat.router import router as chat_router
from app.features.itinerary.router import router as itinerary_router
from app.features.places.router import router as places_router

app = FastAPI(
    title="TravelMate AI Service",
    version="1.0.0",
    description="Microservice AI Local (Ollama + Geoapify) - Feature-Based"
)

# Register Feature-Based Routers
app.include_router(chat_router)
app.include_router(itinerary_router)
app.include_router(places_router)

@app.get("/")
def root():
    return {
        "status": "online",
        "model": settings.OLLAMA_MODEL,
        "message": "TravelMate Local AI Service is ready (Feature-Based)!"
    }