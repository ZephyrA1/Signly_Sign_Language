import 'package:flutter/material.dart';
import 'services/font_size_service.dart';
import 'services/auth_service.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FontSizeService.instance.load();
  await AuthService.instance.init();
  runApp(const SignlyApp());
}

class SignlyApp extends StatelessWidget {
  const SignlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: FontSizeService.instance,
      builder: (context, _) => MediaQuery(
        data: MediaQueryData.fromView(View.of(context)).copyWith(
          textScaler: TextScaler.linear(FontSizeService.instance.scaleFactor),
        ),
        child: MaterialApp(
          title: 'Signly',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/welcome': (context) => const WelcomeScreen(),
            '/account-setup': (context) => const AccountSetupScreen(),
            '/signin': (context) => const SignInScreen(),
            '/main': (context) => const MainScreen(),
            '/camera-practice': (context) => const CameraPracticeScreen(),
            '/scenario-practice': (context) => const ScenarioPracticeScreen(),
            '/error-detective': (context) => const ErrorDetectiveScreen(),
            '/sign-interpretation': (context) => const SignInterpretationScreen(),
            '/mistake-review': (context) => const MistakeReviewScreen(),
            '/free-practice': (context) => const FreePracticeScreen(),
            '/weak-areas': (context) => const WeakAreasScreen(),
            '/deaf-culture': (context) => const DeafCultureScreen(),
            '/settings': (context) => const SettingsScreen(),
          },
          onGenerateRoute: (settings) {
            // Handle routes that pass non-Map arguments first
            if (settings.name == '/learning-preferences') {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => const LearningPreferencesScreen(),
              );
            }

            if (settings.name == '/start-goal') {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => const StartGoalScreen(),
              );
            }

            if (settings.name == '/vocabulary-detail') {
              final item = settings.arguments as VocabularyItem;
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => VocabularyDetailScreen(item: item),
              );
            }

            final args = settings.arguments as Map<String, dynamic>? ?? {};

            // Helper to parse the signs list safely
            List<String> parseSigns(dynamic raw) =>
                raw == null ? [] : (raw as List).cast<String>();

            if (settings.name == '/lesson-intro') {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => LessonIntroScreen(
                  unitTitle: args['unitTitle'] as String,
                  lessonTitle: args['lessonTitle'] as String,
                  lessonId: args['lessonId'] as String,
                ),
              );
            }

            if (settings.name == '/lesson-watch') {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => LessonWatchScreen(
                  unitTitle: args['unitTitle'] as String? ?? '',
                  lessonTitle: args['lessonTitle'] as String,
                  lessonId: args['lessonId'] as String,
                  signIndex: (args['signIndex'] as int?) ?? 0,
                  isReview: (args['isReview'] as bool?) ?? false,
                ),
              );
            }

            if (settings.name == '/lesson-recognition') {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => LessonRecognitionScreen(
                  unitTitle: args['unitTitle'] as String? ?? '',
                  lessonTitle: args['lessonTitle'] as String,
                  lessonId: args['lessonId'] as String,
                  signIndex: (args['signIndex'] as int?) ?? 0,
                  isReview: (args['isReview'] as bool?) ?? false,
                ),
              );
            }

            if (settings.name == '/lesson-context') {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => LessonContextScreen(
                  unitTitle: args['unitTitle'] as String? ?? '',
                  lessonTitle: args['lessonTitle'] as String,
                  lessonId: args['lessonId'] as String,
                  signIndex: (args['signIndex'] as int?) ?? 0,
                  isReview: (args['isReview'] as bool?) ?? false,
                ),
              );
            }

            if (settings.name == '/lesson-error') {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => LessonErrorScreen(
                  unitTitle: args['unitTitle'] as String? ?? '',
                  lessonTitle: args['lessonTitle'] as String,
                  lessonId: args['lessonId'] as String,
                  signIndex: (args['signIndex'] as int?) ?? 0,
                  isReview: (args['isReview'] as bool?) ?? false,
                ),
              );
            }

            if (settings.name == '/lesson-camera') {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => LessonCameraScreen(
                  unitTitle: args['unitTitle'] as String? ?? '',
                  lessonTitle: args['lessonTitle'] as String,
                  lessonId: args['lessonId'] as String,
                  signIndex: (args['signIndex'] as int?) ?? 0,
                  isReview: (args['isReview'] as bool?) ?? false,
                ),
              );
            }

            if (settings.name == '/lesson-reflection') {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => LessonReflectionScreen(
                  unitTitle: args['unitTitle'] as String? ?? '',
                  lessonTitle: args['lessonTitle'] as String,
                  lessonId: args['lessonId'] as String,
                ),
              );
            }

            if (settings.name == '/lesson-summary') {
              return MaterialPageRoute(
                settings: settings,
                builder: (_) => LessonSummaryScreen(
                  lessonTitle: args['lessonTitle'] as String,
                  lessonId: args['lessonId'] as String,
                ),
              );
            }

            return null;
          },
        ),
      ),
    );
  }
}