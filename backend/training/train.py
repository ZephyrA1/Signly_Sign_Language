"""
YOLO11 Training Script for Signly Sign Language Detection

This script fine-tunes a YOLO11-nano model on an ASL sign language dataset
to detect 10 sign classes: Hello, Thank You, Please, Sorry, Yes, No,
Teacher, Mother, Father, Friend.

Prerequisites:
  1. Run dataset_setup.py first to prepare the dataset
  2. Ensure data is in backend/data/ with train/ and val/ splits
  3. Ensure data/data.yaml exists

Usage:
  cd backend
  python training/train.py

After training:
  Copy runs/signly_asl/weights/best.pt to backend/models/best.pt
"""

import os
import sys
import shutil

# Paths
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.dirname(SCRIPT_DIR)
DATA_YAML = os.path.join(BACKEND_DIR, "data", "data.yaml")
MODELS_DIR = os.path.join(BACKEND_DIR, "models")
RUNS_DIR = os.path.join(BACKEND_DIR, "runs")


def check_prerequisites():
    """Verify dataset and config files exist."""
    if not os.path.exists(DATA_YAML):
        print(f"ERROR: data.yaml not found at {DATA_YAML}")
        print("Run dataset_setup.py first!")
        sys.exit(1)

    train_images = os.path.join(BACKEND_DIR, "data", "train", "images")
    if not os.path.exists(train_images) or not os.listdir(train_images):
        print(f"ERROR: No training images found in {train_images}")
        print("Add your dataset images first!")
        sys.exit(1)

    print("Prerequisites check passed!")


def train():
    """Run YOLO11 training."""
    from ultralytics import YOLO

    print("\n" + "=" * 50)
    print("  Starting YOLO11 Training for Signly")
    print("=" * 50)

    # Load YOLO11-nano pretrained on COCO
    # Using nano for fast inference (ideal for real-time demo)
    model = YOLO("yolo11n.pt")

    # Fine-tune on our ASL sign language dataset
    results = model.train(
        data=DATA_YAML,
        epochs=50,           # 50 epochs is good for small datasets
        imgsz=640,           # Standard YOLO input size
        batch=16,            # Adjust based on GPU memory (8 if low VRAM)
        name="signly_asl",   # Run name
        project=RUNS_DIR,    # Save runs here
        patience=10,         # Early stopping if no improvement for 10 epochs
        save=True,           # Save checkpoints
        plots=True,          # Generate training plots
        verbose=True,
    )

    print("\n" + "=" * 50)
    print("  Training Complete!")
    print("=" * 50)

    # Copy best model to backend/models/
    best_model_path = os.path.join(RUNS_DIR, "signly_asl", "weights", "best.pt")
    if os.path.exists(best_model_path):
        dest_path = os.path.join(MODELS_DIR, "best.pt")
        shutil.copy2(best_model_path, dest_path)
        print(f"\nBest model copied to: {dest_path}")
        print("You can now start the server with: python run.py")
    else:
        print(f"\nWARNING: best.pt not found at expected path: {best_model_path}")
        print("Check the runs/ directory for your trained weights.")

    return results


def main():
    check_prerequisites()
    train()


if __name__ == "__main__":
    main()
