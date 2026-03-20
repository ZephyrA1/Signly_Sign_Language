"""Server configuration with environment variable overrides."""

import os

HOST = os.getenv("SIGNLY_HOST", "0.0.0.0")
PORT = int(os.getenv("SIGNLY_PORT", "8001"))
MODEL_PATH = os.getenv("SIGNLY_MODEL_PATH", os.path.join(os.path.dirname(__file__), "..", "models", "best.pt"))
CONFIDENCE_THRESHOLD = float(os.getenv("SIGNLY_CONFIDENCE", "0.4"))
