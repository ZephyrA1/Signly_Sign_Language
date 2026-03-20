import 'package:flutter/material.dart';
import 'theme.dart';
import 'models/lesson_data.dart';

// Auth screens
import 'screens/auth/splash_screen.dart';
import 'screens/auth/welcome_screen.dart';
import 'screens/auth/account_setup_screen.dart';
import 'screens/auth/sign_in_screen.dart';
import 'screens/auth/learning_preferences_screen.dart';
import 'screens/auth/start_goal_screen.dart';

// Main screens
import 'screens/main/main_screen.dart';

// Learn flow screens
import 'screens/learn/lesson_intro_screen.dart';
import 'screens/learn/lesson_watch_screen.dart';
import 'screens/learn/lesson_recognition_screen.dart';
import 'screens/learn/lesson_context_screen.dart';
import 'screens/learn/lesson_error_screen.dart';
import 'screens/learn/lesson_camera_screen.dart';
import 'screens/learn/lesson_reflection_screen.dart';
import 'screens/learn/lesson_summary_screen.dart';

// Practice screens
import 'screens/practice/camera_practice_screen.dart';
import 'screens/practice/scenario_practice_screen.dart';
import 'screens/practice/error_detective_screen.dart';
import 'screens/practice/sign_interpretation_screen.dart';
import 'screens/practice/mistake_review_screen.dart';

// Support screens
import 'screens/support/vocabulary_detail_screen.dart';
import 'screens/support/free_practice_screen.dart';
import 'screens/support/weak_areas_screen.dart';
import 'screens/support/deaf_culture_screen.dart';
import 'screens/support/settings_screen.dart';

void main() {
  runApp(const SignlyApp());
}

class SignlyApp extends StatelessWidget {
  const SignlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Signly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/splash',
      routes: {
        // Onboarding
        '/splash': (context) => const SplashScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/account-setup': (context) => const AccountSetupScreen(),
        '/signin': (context) => const SignInScreen(),
        '/learning-preferences': (context) => const LearningPreferencesScreen(),
        '/start-goal': (context) => const StartGoalScreen(),

        // Main app
        '/main': (context) => const MainScreen(),

        // Practice screens
        '/camera-practice': (context) => const CameraPracticeScreen(),
        '/scenario-practice': (context) => const ScenarioPracticeScreen(),
        '/error-detective': (context) => const ErrorDetectiveScreen(),
        '/sign-interpretation': (context) => const SignInterpretationScreen(),
        '/mistake-review': (context) => const MistakeReviewScreen(),

        // Support screens
        '/free-practice': (context) => const FreePracticeScreen(),
        '/weak-areas': (context) => const WeakAreasScreen(),
        '/deaf-culture': (context) => const DeafCultureScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
      onGenerateRoute: (settings) {
        // Lesson intro
        if (settings.name == '/lesson-intro') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => LessonIntroScreen(
              unitTitle: args['unitTitle'] as String,
              lessonTitle: args['lessonTitle'] as String,
              lessonId: args['lessonId'] as String,
            ),
          );
        }

        // Lesson watch
        if (settings.name == '/lesson-watch') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => LessonWatchScreen(
              lessonTitle: args['lessonTitle'] as String,
              lessonId: args['lessonId'] as String,
            ),
          );
        }

        // Lesson recognition
        if (settings.name == '/lesson-recognition') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => LessonRecognitionScreen(
              lessonTitle: args['lessonTitle'] as String,
              lessonId: args['lessonId'] as String,
            ),
          );
        }

        // Lesson context
        if (settings.name == '/lesson-context') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => LessonContextScreen(
              lessonTitle: args['lessonTitle'] as String,
              lessonId: args['lessonId'] as String,
            ),
          );
        }

        // Lesson error
        if (settings.name == '/lesson-error') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => LessonErrorScreen(
              lessonTitle: args['lessonTitle'] as String,
              lessonId: args['lessonId'] as String,
            ),
          );
        }

        // Lesson camera
        if (settings.name == '/lesson-camera') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => LessonCameraScreen(
              lessonTitle: args['lessonTitle'] as String,
              lessonId: args['lessonId'] as String,
            ),
          );
        }

        // Lesson reflection
        if (settings.name == '/lesson-reflection') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => LessonReflectionScreen(
              lessonTitle: args['lessonTitle'] as String,
              lessonId: args['lessonId'] as String,
            ),
          );
        }

        // Lesson summary
        if (settings.name == '/lesson-summary') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => LessonSummaryScreen(
              lessonTitle: args['lessonTitle'] as String,
              lessonId: args['lessonId'] as String,
            ),
          );
        }

        // Vocabulary detail
        if (settings.name == '/vocabulary-detail') {
          final item = settings.arguments as VocabularyItem;
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => VocabularyDetailScreen(item: item),
          );
        }

        return null;
      },
    );
  }
}
