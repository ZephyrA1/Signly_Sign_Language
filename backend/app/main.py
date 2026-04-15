

import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .detection import load_model, is_model_loaded, detect_sign
from .models import DetectionRequest, DetectionResponse, HealthResponse

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Load the YOLO model on startup."""
    logger.info("Starting Signly Detection Server...")
    loaded = load_model()
    if loaded:
        logger.info("YOLO model loaded — real detection active")
    else:
        logger.warning("No YOLO model found — running in MOCK mode (random detections for testing)")
    yield
    logger.info("Shutting down Signly Detection Server...")


app = FastAPI(
    title="Signly Sign Language Detection API",
    description="Real-time ASL sign detection using YOLO11",
    version="1.0.0",
    lifespan=lifespan,
)

# Allow Flutter app to connect from any origin (development)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/health", response_model=HealthResponse)
async def health_check():
    """Check if the server is running and model is loaded."""
    return HealthResponse(
        status="ok",
        model_loaded=is_model_loaded(),
    )


@app.post("/detect", response_model=DetectionResponse)
async def detect(request: DetectionRequest):
    """
    Detect sign language from a base64-encoded image.

    Send a JPEG image as a base64 string. Optionally include
    `expected_sign` to check if the detected sign matches.
    """
    return detect_sign(
        base64_image=request.image,
        expected_sign=request.expected_sign,
    )
