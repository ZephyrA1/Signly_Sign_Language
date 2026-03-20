"""Pydantic request/response schemas for the detection API."""

from pydantic import BaseModel
from typing import Optional


class DetectionRequest(BaseModel):
    """Request body for the /detect endpoint."""
    image: str  # base64-encoded JPEG image
    expected_sign: Optional[str] = None  # optional: what sign the user should be performing


class SingleDetection(BaseModel):
    """A single detection result from the YOLO model."""
    sign: str
    confidence: float
    bbox: list[float]  # [x1, y1, x2, y2]


class DetectionResponse(BaseModel):
    """Response body from the /detect endpoint."""
    detected_sign: str  # highest-confidence sign, or "none"
    confidence: float  # 0.0 to 1.0
    is_correct: Optional[bool] = None  # if expected_sign was provided
    all_detections: list[SingleDetection] = []


class HealthResponse(BaseModel):
    """Response body from the /health endpoint."""
    status: str
    model_loaded: bool
