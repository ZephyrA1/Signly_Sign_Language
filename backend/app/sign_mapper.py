

SIGN_CLASSES = {
    0: "Hello",
    1: "Thank You",
    2: "Please",
    3: "Sorry",
    4: "Yes",
    5: "No",
    6: "Teacher",
    7: "Mother",
    8: "Father",
    9: "Friend",
}

# Reverse lookup: sign name -> class index
SIGN_TO_INDEX = {v: k for k, v in SIGN_CLASSES.items()}


def get_sign_name(class_index: int) -> str:
    """Return the sign name for a YOLO class index, or 'Unknown' if not mapped."""
    return SIGN_CLASSES.get(class_index, "Unknown")


def get_class_count() -> int:
    """Return the total number of sign classes."""
    return len(SIGN_CLASSES)
