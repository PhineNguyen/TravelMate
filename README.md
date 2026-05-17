# TravelMate

TravelMate is an intelligent mobile travel planning platform designed to simplify personalized trip organization through artificial intelligence.

The system automatically generates optimized travel itineraries based on user preferences, budget constraints, trip duration, destination context, and real-time weather conditions. By integrating large language models from Hugging Face with a scalable microservice architecture, TravelMate AI provides dynamic travel recommendations and adaptive schedule generation for a smarter travel experience.

## Key Features

- AI-powered personalized itinerary generation
- Smart trip planning based on budget and travel preferences
- Real-time weather-aware schedule adjustment
- Budget estimation and expense tracking
- User preference learning and adaptive recommendations
- Secure authentication with JWT
- Mobile-first experience built with Flutter
- RESTful backend architecture with Spring Boot
- AI orchestration through FastAPI and Hugging Face models
- Dockerized multi-service deployment

## Architecture

TravelMate AI follows a distributed service architecture:

- **Frontend:** Flutter (Riverpod, Dio, Hive, GoRouter)
- **Backend API:** Spring Boot (Spring Security, JWT, JPA, Hibernate)
- **AI Service:** FastAPI + Hugging Face Inference API
- **Database:** PostgreSQL
- **Caching:** Redis (optional future enhancement)
- **Deployment:** Docker & Docker Compose

## Core Workflow

1. User creates a trip plan
2. Backend validates trip constraints
3. AI service generates optimized itinerary
4. Weather context enriches schedule recommendations
5. Mobile client renders dynamic trip timeline
6. User tracks expenses and trip analytics

## Project Goals

TravelMate AI aims to:

- Reduce manual trip planning time
- Deliver highly personalized travel experiences
- Optimize travel cost efficiency
- Adapt itineraries dynamically to environmental changes
- Demonstrate practical AI integration in mobile software systems

## Technical Highlights

- Clean Architecture
- Object-Oriented Design Principles
- JWT Authentication & Authorization
- Prompt Engineering for Structured AI Output
- API-driven Service Communication
- Dockerized Microservice Deployment
- Scalable System Design

## Status

Currently under active development as an AI-integrated mobile system engineering project focused on demonstrating full-stack mobile development, backend architecture, and applied AI orchestration.
