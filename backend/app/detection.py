"""YOLO11 model loading and inference for sign language detection."""

import base64
import os
import logging

import cv2
import numpy as np

from .config import MODEL_PATH, CONFIDENCE_THRESHOLD
from .sign_mapper import get_sign_name
from .models import DetectionResponse, SingleDetection

logger = logging.getLogger(__name__)

# Global model reference — loaded once at startup
_model = None
_model_loaded = False


def load_model() -> bool:
    """Load the YOLO11 model from disk. Returns True if successful."""
    global _model, _model_loaded

    if not os.path.exists(MODEL_PATH):
        logger.warning(f"Model file not found at {MODEL_PATH}. Running in mock mode.")
        _model_loaded = False
        return False

    try:
        from ultralytics import YOLO
        _model = YOLO(MODEL_PATH)
        _model_loaded = True
        logger.info(f"YOLO model loaded successfully from {MODEL_PATH}")
        return True
    except Exception as e:
        logger.error(f"Failed to load YOLO model: {e}")
        _model_loaded = False
        return False


def is_model_loaded() -> bool:
    """Check whether the YOLO model is loaded and ready."""
    return _model_loaded


def decode_base64_image(base64_string: str) -> np.ndarray:
    """Decode a base64-encoded JPEG/PNG string into an OpenCV image (BGR numpy array)."""
    # Remove data URI prefix if present (e.g., "data:image/jpeg;base64,...")
    if "," in base64_string:
        base64_string = base64_string.split(",", 1)[1]

    image_bytes = base64.b64decode(base64_string)
    np_array = np.frombuffer(image_bytes, dtype=np.uint8)
    image = cv2.imdecode(np_array, cv2.IMREAD_COLOR)

    if image is None:
        raise ValueError("Failed to decode image from base64 string")

    return image


def detect_sign(base64_image: str, expected_sign: str | None = None) -> DetectionResponse:
    """
    Run sign language detection on a base64-encoded image.

    If expected_sign is provided, the response includes whether the
    detected sign matches the expected one.

    Falls back to mock detection if no model is loaded.
    """
    if not _model_loaded or _model is None:
        return _mock_detect(expected_sign)

    try:
        image = decode_base64_image(base64_image)

        # Run YOLO inference
        results = _model.predict(
            source=image,
            conf=CONFIDENCE_THRESHOLD,
            verbose=False,
        )

        all_detections: list[SingleDetection] = []
        best_detection: SingleDetection | None = None

        for result in results:
            if result.boxes is not None:
                for box in result.boxes:
                    class_id = int(box.cls[0].item())
                    confidence = float(box.conf[0].item())
                    bbox = box.xyxy[0].tolist()
                    sign_name = get_sign_name(class_id)

                    detection = SingleDetection(
                        sign=sign_name,
                        confidence=round(confidence, 3),
                        bbox=[round(b, 1) for b in bbox],
                    )
                    all_detections.append(detection)

                    if best_detection is None or confidence > best_detection.confidence:
                        best_detection = detection

        # Build response
        if best_detection is not None:
            is_correct = None
            if expected_sign is not None:
                is_correct = (
                    best_detection.sign.lower() == expected_sign.lower()
                    and best_detection.confidence >= 0.5
                )

            return DetectionResponse(
                detected_sign=best_detection.sign,
                confidence=best_detection.confidence,
                is_correct=is_correct,
                all_detections=all_detections,
            )
        else:
            return DetectionResponse(
                detected_sign="none",
                confidence=0.0,
                is_correct=False if expected_sign else None,
                all_detections=[],
            )

    except Exception as e:
        logger.error(f"Detection error: {e}")
        return DetectionResponse(
            detected_sign="error",
            confidence=0.0,
            is_correct=None,
            all_detections=[],
        )


def _mock_detect(expected_sign: str | None = None) -> DetectionResponse:
    """Return a mock detection response when no model is loaded.

    This allows testing the Flutter app without a trained model.
    The mock randomly detects the expected sign with varying confidence.
    """
    import random

    # 70% chance of detecting the expected sign (for demo purposes)
    if expected_sign and random.random() < 0.7:
        confidence = round(random.uniform(0.6, 0.95), 3)
        return DetectionResponse(
            detected_sign=expected_sign,
            confidence=confidence,
            is_correct=True,
            all_detections=[
                SingleDetection(
                    sign=expected_sign,
                    confidence=confidence,
                    bbox=[100.0, 80.0, 400.0, 450.0],
                )
            ],
        )
    else:
        # Detect a random sign or nothing
        signs = ["Hello", "Thank You", "Please", "Sorry", "Yes", "No"]
        detected = random.choice(signs)
        confidence = round(random.uniform(0.3, 0.7), 3)
        is_correct = None
        if expected_sign:
            is_correct = detected.lower() == expected_sign.lower() and confidence >= 0.5

        return DetectionResponse(
            detected_sign=detected,
            confidence=confidence,
            is_correct=is_correct,
            all_detections=[
                SingleDetection(
                    sign=detected,
                    confidence=confidence,
                    bbox=[120.0, 90.0, 380.0, 430.0],
                )
            ],
        )
