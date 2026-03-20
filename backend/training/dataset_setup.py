"""
Dataset Setup for Signly Sign Language Detection

This script helps download and organize an ASL sign language dataset
for training YOLO11. It supports two methods:
  1. Roboflow Universe download (recommended)
  2. Manual dataset organization

The 10 target sign classes:
  Hello, Thank You, Please, Sorry, Yes, No, Teacher, Mother, Father, Friend

Usage:
  python dataset_setup.py --method roboflow --api-key YOUR_KEY
  python dataset_setup.py --method manual
"""

import os
import sys
import argparse
import yaml

# Paths relative to this script
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
BACKEND_DIR = os.path.dirname(SCRIPT_DIR)
DATA_DIR = os.path.join(BACKEND_DIR, "data")

SIGN_CLASSES = [
    "Hello",
    "Thank You",
    "Please",
    "Sorry",
    "Yes",
    "No",
    "Teacher",
    "Mother",
    "Father",
    "Friend",
]


def create_data_yaml():
    """Generate the data.yaml config file for YOLO training."""
    data_yaml = {
        "path": DATA_DIR,
        "train": "train/images",
        "val": "val/images",
        "nc": len(SIGN_CLASSES),
        "names": {i: name for i, name in enumerate(SIGN_CLASSES)},
    }

    yaml_path = os.path.join(DATA_DIR, "data.yaml")
    with open(yaml_path, "w") as f:
        yaml.dump(data_yaml, f, default_flow_style=False, sort_keys=False)

    print(f"Created data.yaml at: {yaml_path}")
    return yaml_path


def setup_directory_structure():
    """Create the required directory structure for YOLO dataset."""
    dirs = [
        os.path.join(DATA_DIR, "train", "images"),
        os.path.join(DATA_DIR, "train", "labels"),
        os.path.join(DATA_DIR, "val", "images"),
        os.path.join(DATA_DIR, "val", "labels"),
    ]
    for d in dirs:
        os.makedirs(d, exist_ok=True)
        print(f"  Created: {d}")


def download_roboflow(api_key: str):
    """Download ASL dataset from Roboflow Universe."""
    try:
        from roboflow import Roboflow
    except ImportError:
        print("Installing roboflow package...")
        os.system(f"{sys.executable} -m pip install roboflow")
        from roboflow import Roboflow

    print("\nConnecting to Roboflow...")
    rf = Roboflow(api_key=api_key)

    # NOTE: Replace with your specific project/version from Roboflow Universe.
    # Search "ASL sign language detection" on https://universe.roboflow.com/
    # Example project (you may need to find one with your 10 target signs):
    print("""
    ============================================================
    INSTRUCTIONS:
    1. Go to https://universe.roboflow.com/
    2. Search for "ASL sign language detection"
    3. Find a dataset with your target signs
    4. Click "Download Dataset" → YOLO format
    5. Note the workspace, project, and version numbers
    6. Update the lines below with your specific project info
    ============================================================
    """)

    # Example — update these values with your Roboflow project:
    # project = rf.workspace("your-workspace").project("your-project")
    # dataset = project.version(1).download("yolov8", location=DATA_DIR)

    print("After downloading, ensure the data is organized as:")
    print(f"  {DATA_DIR}/train/images/  (training images)")
    print(f"  {DATA_DIR}/train/labels/  (training labels)")
    print(f"  {DATA_DIR}/val/images/    (validation images)")
    print(f"  {DATA_DIR}/val/labels/    (validation labels)")


def setup_manual():
    """Print instructions for manual dataset setup."""
    print("""
    ============================================================
    MANUAL DATASET SETUP
    ============================================================

    1. Collect images for each of the 10 sign classes:
       Hello, Thank You, Please, Sorry, Yes, No,
       Teacher, Mother, Father, Friend

    2. Aim for 100-200 images per class (total: 1000-2000 images)

    3. Annotate images using one of:
       - Roboflow (https://roboflow.com) — free for small projects
       - CVAT (https://www.cvat.ai/) — open source
       - LabelImg (https://github.com/HumanSignal/labelImg)

    4. Export annotations in YOLO format:
       Each image.jpg should have a corresponding image.txt with:
       class_id x_center y_center width height
       (all values normalized 0-1)

    5. Split into train (80%) and val (20%) sets

    6. Place files in:
    """)
    print(f"       {DATA_DIR}/train/images/  ← training images (.jpg)")
    print(f"       {DATA_DIR}/train/labels/  ← training labels (.txt)")
    print(f"       {DATA_DIR}/val/images/    ← validation images (.jpg)")
    print(f"       {DATA_DIR}/val/labels/    ← validation labels (.txt)")
    print("""
    7. Run this script again to generate data.yaml:
       python dataset_setup.py --method manual
    ============================================================
    """)


def main():
    parser = argparse.ArgumentParser(description="Signly Dataset Setup")
    parser.add_argument(
        "--method",
        choices=["roboflow", "manual"],
        default="manual",
        help="Dataset acquisition method",
    )
    parser.add_argument(
        "--api-key",
        type=str,
        default=None,
        help="Roboflow API key (required for roboflow method)",
    )
    args = parser.parse_args()

    print("=" * 50)
    print("  Signly Dataset Setup")
    print("=" * 50)

    # Create directory structure
    print("\nSetting up directories...")
    setup_directory_structure()

    # Generate data.yaml
    print("\nGenerating data.yaml...")
    create_data_yaml()

    # Method-specific setup
    if args.method == "roboflow":
        if not args.api_key:
            print("\nERROR: --api-key is required for roboflow method")
            sys.exit(1)
        download_roboflow(args.api_key)
    else:
        setup_manual()

    print("\nDone! Next step: run training with train.py")


if __name__ == "__main__":
    main()
