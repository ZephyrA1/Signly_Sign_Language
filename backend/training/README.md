# Signly YOLO11 Training Guide

## Overview

This guide walks you through training a YOLO11 model to detect 10 ASL (American Sign Language) signs for the Signly app.

**Target signs:** Hello, Thank You, Please, Sorry, Yes, No, Teacher, Mother, Father, Friend

## Prerequisites

- Python 3.9+
- NVIDIA GPU with CUDA (recommended for training; CPU works but is slow)
- ~2GB disk space for dataset + model

## Step 1: Install Dependencies

```bash
cd backend
pip install -r requirements.txt
pip install roboflow  # optional, for Roboflow dataset download
```

## Step 2: Prepare Dataset

### Option A: Roboflow Universe (Recommended)

1. Go to [Roboflow Universe](https://universe.roboflow.com/)
2. Search for **"ASL sign language detection"**
3. Find a dataset covering the 10 target signs
4. Download in **YOLOv8 format**
5. Extract into `backend/data/` so the structure is:
   ```
   data/
   ├── train/
   │   ├── images/    (training images)
   │   └── labels/    (YOLO format .txt labels)
   ├── val/
   │   ├── images/    (validation images)
   │   └── labels/    (YOLO format .txt labels)
   └── data.yaml
   ```

### Option B: Custom Data Collection

1. Run the setup script:
   ```bash
   python training/dataset_setup.py --method manual
   ```
2. Collect 100-200 images per sign class (webcam, phone, etc.)
3. Annotate using [Roboflow](https://roboflow.com) or [CVAT](https://cvat.ai)
4. Export in YOLO format and place in the directory structure above

### Generate data.yaml

```bash
python training/dataset_setup.py --method manual
```

This creates `data/data.yaml` with the correct class mapping.

## Step 3: Train the Model

```bash
cd backend
python training/train.py
```

Training will:
- Download YOLO11-nano base weights automatically
- Fine-tune on your dataset for 50 epochs
- Save the best model to `backend/models/best.pt`
- Generate training plots in `backend/runs/signly_asl/`

**Training time:** ~30 min on GPU, ~2-4 hours on CPU

## Step 4: Verify the Model

Start the server and test:

```bash
python run.py
```

Then open http://localhost:8000/docs to test the API interactively.

Or use curl:
```bash
# Health check
curl http://localhost:8000/health

# Test detection (replace BASE64_IMAGE with actual base64 data)
curl -X POST http://localhost:8000/detect \
  -H "Content-Type: application/json" \
  -d '{"image": "BASE64_IMAGE", "expected_sign": "Hello"}'
```

## Troubleshooting

- **"No YOLO model found — running in MOCK mode"**: The server works without a trained model by returning random detections. Train a model to get real detections.
- **Out of memory during training**: Reduce `batch` size in `train.py` (try 8 or 4).
- **Low accuracy**: Collect more training data or increase epochs.
- **CUDA not available**: Training will use CPU (slower but works). Install CUDA toolkit for GPU support.

## Model Performance Tips

- More diverse training data = better real-world performance
- Include images with different lighting, backgrounds, and skin tones
- Data augmentation is applied automatically by YOLO11
- Aim for at least 80% mAP on validation set before deploying
