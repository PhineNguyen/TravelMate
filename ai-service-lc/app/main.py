from fastapi import FastAPI
from app.routers import places, itinerary
from app.config import settings

app = FastAPI(
    title="TravelMate AI Service",
    version="1.0.0",
    description="Microservice AI Local (Ollama + Geoapify)"
)

# Register Routers
app.include_router(places.router)
app.include_router(itinerary.router)

@app.get("/")
def root():
    return {
        "status": "online",
        "model": settings.OLLAMA_MODEL,
        "message": "TravelMate Local AI Service is ready!"
    }