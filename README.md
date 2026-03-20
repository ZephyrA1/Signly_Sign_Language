# Signly - Sign Language Learning App

A Flutter-based mobile application designed to teach sign language through structured, pedagogically grounded lessons. Built with educational best practices including Reusable Learning Objects (RLOs), Universal Design for Learning (UDL), and measurable learning outcomes.

A demo video of the app is available at [`Signly_Prototype_Demo.mp4`](Signly_Prototype_Demo.mp4) in the project root.

---

## Table of Contents

1. [Installation Guide](#installation-guide)
2. [Project Structure](#project-structure)
3. [User Guide](#user-guide)
4. [Educational Design](#educational-design)
5. [Reusable Learning Objects (RLOs)](#reusable-learning-objects-rlos)
6. [Universal Design for Learning (UDL)](#universal-design-for-learning-udl)
7. [UI/UX Design Principles](#uiux-design-principles)
8. [Screen Reference](#screen-reference)

---


## Installation Guide

### Prerequisites

| Requirement        | Version         |
|--------------------|-----------------|
| Flutter SDK        | 3.5.4 or higher |
| Dart SDK           | 3.5.4 or higher |
| Python             | 3.9 or higher   |
| Android Studio     | Latest          |
| Xcode (macOS)      | Latest          |
| VS Code (optional) | Latest          |

### Step-by-Step Setup

1. **Install Flutter SDK**
   - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
   - Add Flutter to your system PATH
   - Verify installation:
     ```bash
     flutter doctor
     ```

2. **Clone the Repository**
   ```bash
   git clone <repository-url>
   cd Signly_Sign_Language
   ```

3. **Install Flutter Dependencies**
   ```bash
   flutter pub get
   ```

4. **Run the App**
   - On Android emulator or device:
     ```bash
     flutter run
     ```
   - On iOS simulator (macOS only):
     ```bash
     flutter run -d ios
     ```
   - On Chrome (web):
     ```bash
     flutter run -d chrome
     ```

5. **Build for Release**
   ```bash
   flutter build apk          # Android
   flutter build ios           # iOS
   flutter build web           # Web
   ```

6. **Build Split APKs (Recommended for Android)**
   ```bash
   flutter build apk --split-per-abi
   ```
   This produces smaller APKs optimized for each CPU architecture.

   **Pre-built APKs** are included in the `apk/` folder at the project root:
   ```
   apk/app-armeabi-v7a-release.apk   (~22 MB, older 32-bit phones)
   apk/app-arm64-v8a-release.apk     (~23 MB, most modern phones)
   apk/app-x86_64-release.apk        (~23 MB, x86 emulators)
   ```

### Installing and Running the APK on Windows

If you want to install the built APK onto an Android device or emulator from a Windows machine:

#### Option A: Using an Android Emulator

1. Open Android Studio and go to **Tools > Device Manager**
2. Create or start an Android Virtual Device (AVD)
3. Once the emulator is running, install the APK:
   ```bash
   flutter install
   ```
   Or use ADB directly:
   ```bash
   adb install apk/app-x86_64-release.apk
   ```
4. The app will appear in the emulator's app drawer as **Signly**

#### Option B: Using a Physical Android Device

1. Enable **Developer Options** on your phone:
   - Go to **Settings > About Phone** and tap **Build Number** 7 times
2. Enable **USB Debugging**:
   - Go to **Settings > Developer Options > USB Debugging** and toggle it on
3. Connect your phone to your Windows PC via USB
4. Accept the USB debugging prompt on your phone
5. Verify the device is detected:
   ```bash
   flutter devices
   ```
6. Install the APK:
   ```bash
   flutter install
   ```
   Or use ADB directly (use `arm64-v8a` for most modern phones):
   ```bash
   adb install apk/app-arm64-v8a-release.apk
   ```

#### Option C: Transfer the APK Manually

1. Copy the APK file from the `apk/` folder to your phone via USB, email, or cloud storage (e.g., Google Drive)
2. On your phone, open the APK file
3. If prompted, enable **Install from Unknown Sources** in your phone's settings
4. Tap **Install** and then **Open** to launch the app

#### Verifying Your Setup

Run these commands to confirm everything is working:
```bash
flutter doctor       # Check that Flutter and Android toolchain are configured
flutter devices      # Confirm your device or emulator is detected
```

### Troubleshooting

| Issue | Solution |
|-------|----------|
| `flutter doctor` shows issues | Follow the instructions provided by each check |
| Dependencies fail to install | Run `flutter clean` then `flutter pub get` |
| Build errors | Ensure Flutter SDK version >= 3.5.4 |
| Google Fonts not loading | Check internet connection (fonts download on first run) |
| Camera not working on web | Close other apps using the camera, check Chrome permissions |
| Camera "not readable" error | Close Zoom/Teams/OBS, try a different browser |

---

## Project Structure

```
Signly_Sign_Language/
├── lib/
│   ├── main.dart                          # App entry point & route configuration
│   ├── theme.dart                         # Global dark theme definition
│   ├── config/
│   │   └── api_config.dart                # Backend server URL & detection settings
│   ├── services/
│   │   └── detection_service.dart         # HTTP client for backend communication
│   ├── models/
│   │   └── lesson_data.dart               # Data models (units, vocab, scenarios, sign maps)
│   ├── widgets/
│   │   └── common_widgets.dart            # Reusable UI components & video players
│   └── screens/
│       ├── auth/                          # Onboarding & authentication (5 screens)
│       ├── main/                          # Main app tabs (6 screens)
│       ├── learn/                         # Lesson flow (8 screens)
│       ├── practice/                      # Practice modes (5 screens)
│       └── support/                       # Support pages (5 screens)
├── assets/
│   ├── *.png                              # App images and flags
│   └── videos/                            # Sign demonstration videos
├── android/                               # Android platform configuration
├── ios/                                   # iOS platform configuration
├── web/                                   # Web platform configuration
├── windows/                               # Windows platform configuration
├── apk/                                   # Pre-built release APKs
├── build/                                 # Build output
└── pubspec.yaml                           # Flutter dependencies & assets
```

---

## User Guide

### 1. Getting Started (Onboarding Flow)

The onboarding process consists of 5 streamlined screens:

**Screen 1: Splash Screen**
- App logo and branding displayed
- Automatically transitions to the Welcome screen

**Screen 2: Welcome Screen**
- Three key benefits of the app are highlighted
- Two options: "Start Learning" (new users) or "Log In" (returning users)

**Screen 3: Account Setup**
- Enter email, username, and password in a single form
- Alternative sign-up with Google or Apple

**Screen 4: Learning Preferences**
- Select sign language variant (ASL, BSL, LSF, CSL, RSL)
- Choose experience level and learning purpose
- Set daily practice goal and starting level
- All preferences on one scrollable page

**Screen 5: Start Goal**
- Personalized welcome message
- Summary of chosen preferences
- Suggested first steps

```
Onboarding Flow Diagram:

  [Splash] --> [Welcome] --> [Account Setup] --> [Learning Preferences] --> [Start Goal] --> [Main App]
                   |
                   +--> [Sign In] --> [Main App]
```

### 2. Main Navigation (5 Tabs)

After onboarding, the app presents a bottom navigation bar with 5 tabs:

```
+--------+----------+-------+----------+---------+
|  Learn | Practice | Vocab | Progress | Profile |
+--------+----------+-------+----------+---------+
```

**Learn Tab** - Browse units and lessons, continue where you left off, track daily goal progress.

**Practice Tab** - Access 5 independent practice modes for targeted skill development.

**Vocabulary Tab** - Search, filter, and review learned signs with category organization.

**Progress Tab** - View learning statistics, streaks, weekly goals, strengths, and areas for improvement.

**Profile Tab** - View user information, quick actions, and access settings.

### 3. Lesson Flow (8 Steps)

Each lesson follows a structured 6-step pedagogical sequence with intro and summary:

```
Lesson Flow Diagram:

  [Lesson Intro]
       |
       v
  [1. Watch & Notice] --> [2. Recognize] --> [3. Context Practice]
                                                      |
                                                      v
  [6. Reflect] <-- [5. Camera Practice] <-- [4. Error Analysis]
       |
       v
  [Lesson Summary]
       |
       v
  [Back to Learn Home]
```

A progress bar at the top tracks completion through all steps. Tapping the close (X) button shows a confirmation dialog before exiting.

**Video Playback Features:**
- Full video player with play/pause, replay, and progress scrubbing
- Slow-motion mode (0.5x) for studying sign details
- Mini video players for side-by-side comparisons
- Videos load from `assets/videos/` with graceful fallback placeholders

**Camera Practice Features:**
- Live camera preview using the device's front camera (or external camera)
- Record button with visual recording indicator
- Success feedback with structured result panel
- Continue button to proceed to the next lesson step

### 4. Practice Modes

| Mode | Description | Skill Focus |
|------|-------------|-------------|
| Camera Practice | Record yourself signing with live camera and model reference | Production |
| Scenario Practice | Choose signs for real-world situations | Context |
| Error Detective | Compare two signs, find the mistake | Analysis |
| Sign Interpretation | Watch a sign, select its meaning | Comprehension |
| Mistake Review | Review commonly missed signs | Remediation |

### 5. Settings & Accessibility

The Settings screen provides comprehensive customization:

- **Account**: Username, email, password management
- **Language**: Sign language variant, level, daily goal, dominant hand
- **Accessibility (UDL)**: Text size slider, animation speed, video playback speed, high contrast mode, captions toggle, haptic feedback
- **Notifications**: Push notification preferences
- **General**: Dark mode, interface language
- **Privacy & Support**: Privacy policy, terms, help

### 6. Confirmation Dialogs

The app uses confirmation dialogs for destructive or irreversible actions:
- **Log Out**: Confirms before signing out (appears in both Profile and Settings)
- **Exit Lesson**: Confirms before abandoning lesson progress
- **Reset Progress**: Confirms before erasing all learning data

```
Confirmation Dialog Example:

  +-----------------------------+
  |        (Warning Icon)       |
  |                             |
  |       Log Out?              |
  |                             |
  |  Are you sure you want to   |
  |  log out? Your progress is  |
  |  saved and will be here     |
  |  when you return.           |
  |                             |
  |  [  Stay  ]  [ Log Out ]   |
  +-----------------------------+
```

---

## Educational Design

### Learning Objectives

Each lesson has clearly stated learning goals displayed on the Lesson Intro screen. Objectives follow the ABCD model:
- **Audience**: The learner
- **Behavior**: Observable action (recognize, produce, apply, analyze)
- **Condition**: Within the lesson context
- **Degree**: Measured through quiz accuracy and practice completion

### Bloom's Taxonomy Integration

The lesson flow progresses through Bloom's taxonomy levels:

```
Bloom's Taxonomy Mapping:

  Remember    -->  Watch & Notice (observe sign details)
  Understand  -->  Recognize (identify sign from options)
  Apply       -->  Context Practice (use in real scenarios)
  Analyze     -->  Error Analysis (compare and find mistakes)
  Create      -->  Camera Practice (produce sign independently)
  Evaluate    -->  Reflect (self-assess learning experience)
```

| Lesson Step | Bloom's Level | Activity |
|-------------|---------------|----------|
| Watch & Notice | Remember | Observe and recall sign details |
| Recognize | Understand | Identify correct sign from options |
| Context Practice | Apply | Use sign in real-world scenario |
| Error Analysis | Analyze | Compare and identify mistakes |
| Camera Practice | Create | Produce the sign independently |
| Reflect | Evaluate | Self-assess learning experience |

### Measurable Outcomes

The Lesson Summary screen provides quantifiable metrics:
- Number of signs learned
- Recognition accuracy percentage
- Context practice results
- Camera practice completion status
- Identified areas for improvement

---

## Reusable Learning Objects (RLOs)

The app implements 7 distinct RLO types, exceeding the minimum requirement of 3-4:

### RLO 1: Interactive Video Demonstration
- **File**: `lesson_watch_screen.dart`
- **Description**: Presents sign demonstrations via video player with replay, slow-motion (0.5x), and progress scrubbing controls, alongside detailed breakdowns of handshape, placement, movement, and facial expression
- **Reusability**: Template works for any sign in any lesson; video assets mapped via `LessonVideoMap`

### RLO 2: Recognition Quiz
- **Files**: `lesson_recognition_screen.dart`, `sign_interpretation_screen.dart`
- **Description**: Multiple-choice questions testing sign recognition with immediate feedback and explanations
- **Reusability**: Accepts any sign with configurable options and answers

### RLO 3: Scenario-Based Context Practice
- **Files**: `lesson_context_screen.dart`, `scenario_practice_screen.dart`
- **Description**: Real-world scenarios requiring appropriate sign selection with situational context
- **Reusability**: Driven by `ScenarioData` model, easily extended with new scenarios

### RLO 4: Error Analysis / Error Detective
- **Files**: `lesson_error_screen.dart`, `error_detective_screen.dart`
- **Description**: Side-by-side sign comparison using mini video players for identifying and classifying errors in handshape, movement, placement, or expression
- **Reusability**: Works with any pair of correct/incorrect sign videos

### RLO 5: Camera-Based Production Practice
- **Files**: `lesson_camera_screen.dart`, `camera_practice_screen.dart`
- **Description**: Live camera preview with model reference video, record button with visual feedback, and structured result panel. Supports optional YOLO11 backend for AI-powered sign detection
- **Reusability**: Applicable to any sign; camera init handles front, rear, and external cameras across web, Android, and iOS

### RLO 6: Self-Reflection & Metacognition
- **File**: `lesson_reflection_screen.dart`
- **Description**: Structured reflection prompts assessing difficulty, improvement, and desire for additional practice
- **Reusability**: Generic reflection framework applicable after any lesson

### RLO 7: Mistake Review / Spaced Repetition
- **File**: `mistake_review_screen.dart`
- **Description**: Aggregated list of commonly missed signs with error classification and frequency tracking
- **Reusability**: Automatically populated from learner performance data

```
RLO Reuse Diagram:

  Lesson Flow:                    Practice Modes:
  +-- Watch (RLO 1)              +-- Camera Practice (RLO 5)
  +-- Recognition (RLO 2)  <-->  +-- Sign Interpretation (RLO 2)
  +-- Context (RLO 3)      <-->  +-- Scenario Practice (RLO 3)
  +-- Error Analysis (RLO 4)<--> +-- Error Detective (RLO 4)
  +-- Camera (RLO 5)             +-- Mistake Review (RLO 7)
  +-- Reflection (RLO 6)

  Each RLO is a self-contained, reusable module that can be
  used in multiple contexts across the app.
```

---

## Universal Design for Learning (UDL)

### Multiple Means of Engagement (The "Why" of Learning)
- **Goal setting**: Daily practice targets and weekly streaks
- **Real-world relevance**: Scenario-based practice with authentic contexts
- **Self-regulation**: Reflection questions after each lesson
- **Progress tracking**: Dashboard with stats, strengths, and weak areas
- **Choice**: Multiple practice modes for learner autonomy
- **Positive feedback**: Success animations and encouraging messages

### Multiple Means of Representation (The "What" of Learning)
- **Visual demonstrations**: Video-based sign instruction with replay and slow-motion
- **Text descriptions**: Written breakdowns of handshape, movement, placement
- **Side-by-side comparisons**: Error analysis with video differentiation
- **Multiple formats**: Same content presented through video, text, and icons
- **Adjustable text size**: Small, Default, Large, Extra Large options
- **High contrast mode**: Enhanced visual distinction
- **Captions**: Toggle for video captions
- **Adjustable video playback speed**: 0.5x, 1x, 1.5x

### Multiple Means of Action & Expression (The "How" of Learning)
- **Multiple choice**: Tap-based recognition quizzes
- **Camera input**: Sign production through device camera with live preview
- **Scenario selection**: Context-based decision making
- **Error identification**: Analytical comparison tasks
- **Reflection responses**: Self-assessment through selection
- **Dominant hand selection**: Left/right hand preference
- **Animation speed control**: Slow, Normal, Fast options
- **Haptic feedback**: Toggle for tactile response

```
UDL Framework in Signly:

  +-------------------+-------------------+-------------------+
  |    Engagement     |  Representation   | Action/Expression |
  |   (The "Why")     |   (The "What")    |   (The "How")     |
  +-------------------+-------------------+-------------------+
  | Daily goals       | Video demos       | Tap quizzes       |
  | Streak tracking   | Text breakdowns   | Camera recording  |
  | Scenario context  | Visual comparison | Scenario choices  |
  | Self-reflection   | Adjustable text   | Error detection   |
  | Practice choice   | High contrast     | Dominant hand     |
  | Progress stats    | Captions          | Haptic feedback   |
  +-------------------+-------------------+-------------------+
```

---

## UI/UX Design Principles

### Visual Design
- **Dark theme**: Reduces eye strain during extended learning sessions
- **Color system**: Blue (#2196F3) primary, Green (#4CAF50) success, Red (#E53935) error, Orange (#FF9800) warning
- **Consistent spacing**: 8px grid system with 20px horizontal padding
- **Rounded corners**: 12-16px border radius for cards and buttons
- **Clear typography hierarchy**: Bold titles, regular body, muted secondary text

### Usability Best Practices
- **Confirmation dialogs**: For all destructive actions (logout, exit, reset)
- **Progress indicators**: Lesson progress bar with percentage
- **Clear navigation**: Back buttons, breadcrumb-style unit/lesson labels
- **Immediate feedback**: Color-coded correct/incorrect responses
- **Consistent layout patterns**: Reusable card and button components
- **Error prevention**: Disabled submit buttons until selection is made
- **Bottom-anchored CTAs**: Primary action buttons always visible at bottom
- **Snackbar notifications**: Brief success/info messages for completed actions
- **Camera fallback**: Graceful handling when camera is unavailable or in use

### Accessibility
- **Semantic widgets**: Proper use of Flutter's accessibility tree
- **Touch targets**: Minimum 48px touch targets for all interactive elements
- **Color + icon**: Never rely on color alone to convey meaning
- **Text contrast**: White text on dark backgrounds meeting WCAG guidelines
- **Scalable text**: User-adjustable text size settings

### Information Architecture
- **5-tab navigation**: Organized by learning activity type
- **Sequential lesson flow**: Clear step-by-step progression
- **Flat hierarchy**: Most screens accessible within 2 taps
- **Consistent patterns**: Same card/list/button patterns throughout

---

## Screen Reference

### Onboarding (5 screens)
| Screen | File | Purpose |
|--------|------|---------|
| Splash | `splash_screen.dart` | App branding and loading |
| Welcome | `welcome_screen.dart` | Value proposition and entry |
| Account Setup | `account_setup_screen.dart` | Registration form |
| Learning Preferences | `learning_preferences_screen.dart` | Personalization |
| Start Goal | `start_goal_screen.dart` | Onboarding completion |

### Main Tabs (6 screens)
| Screen | File | Purpose |
|--------|------|---------|
| Main Shell | `main_screen.dart` | Bottom navigation container |
| Learn Home | `learn_home_screen.dart` | Unit/lesson browser |
| Practice Home | `practice_home_screen.dart` | Practice mode selector |
| Vocabulary | `vocabulary_home_screen.dart` | Sign dictionary |
| Progress | `progress_dashboard_screen.dart` | Learning analytics |
| Profile | `profile_screen.dart` | User account |

### Lesson Flow (8 screens)
| Screen | File | RLO Type |
|--------|------|----------|
| Lesson Intro | `lesson_intro_screen.dart` | Goal setting |
| Watch & Notice | `lesson_watch_screen.dart` | RLO 1: Video Demo |
| Recognition | `lesson_recognition_screen.dart` | RLO 2: Quiz |
| Context | `lesson_context_screen.dart` | RLO 3: Scenario |
| Error Analysis | `lesson_error_screen.dart` | RLO 4: Error Detective |
| Camera Practice | `lesson_camera_screen.dart` | RLO 5: Production |
| Reflection | `lesson_reflection_screen.dart` | RLO 6: Metacognition |
| Summary | `lesson_summary_screen.dart` | Outcomes |

### Practice Modes (5 screens)
| Screen | File | Skill |
|--------|------|-------|
| Camera Practice | `camera_practice_screen.dart` | Production |
| Scenario Practice | `scenario_practice_screen.dart` | Context |
| Error Detective | `error_detective_screen.dart` | Analysis |
| Sign Interpretation | `sign_interpretation_screen.dart` | Comprehension |
| Mistake Review | `mistake_review_screen.dart` | Remediation |

### Support (5 screens)
| Screen | File | Purpose |
|--------|------|---------|
| Vocabulary Detail | `vocabulary_detail_screen.dart` | Sign details |
| Free Practice | `free_practice_screen.dart` | Exploration |
| Weak Areas | `weak_areas_screen.dart` | Targeted review |
| Deaf Culture | `deaf_culture_screen.dart` | Cultural context |
| Settings | `settings_screen.dart` | Preferences & UDL |

### Configuration & Services
| File | Purpose |
|------|---------|
| `config/api_config.dart` | Backend URL, capture interval, confidence thresholds |
| `services/detection_service.dart` | HTTP client for YOLO detection API |
| `models/lesson_data.dart` | Units, vocab, scenarios, lesson-sign maps, video maps |
| `widgets/common_widgets.dart` | Shared UI components, video players, feedback items |

---

## Technologies Used

- **Framework**: Flutter 3.5.4+
- **Language**: Dart
- **Fonts**: Google Fonts (Inter, Indie Flower)
- **Icons**: Material Icons
- **Video**: `video_player` package for sign demonstration playback
- **Camera**: `camera` package for live camera preview and capture
- **HTTP**: `http` package for backend API communication
- **Backend**: Python FastAPI + Uvicorn
- **AI/ML**: YOLO11 (Ultralytics) for sign language detection
- **State Management**: setState (lightweight, no external packages)
- **Navigation**: Named routes with onGenerateRoute for dynamic arguments

### Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | SDK | Core framework |
| `google_fonts` | ^6.3.0 | Custom typography |
| `video_player` | ^2.9.2 | Sign demonstration videos |
| `camera` | ^0.11.0+2 | Live camera preview |
| `http` | ^1.2.0 | Backend API requests |
| `cupertino_icons` | ^1.0.8 | iOS-style icons |

### Backend Dependencies

| Package | Purpose |
|---------|---------|
| `fastapi` | REST API framework |
| `uvicorn` | ASGI server |
| `ultralytics` | YOLO11 model inference |
| `opencv-python-headless` | Image processing |
| `numpy` | Numerical operations |
| `pydantic` | Request/response validation |

---

## License

This project is for educational purposes.
