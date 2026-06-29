import 'package:go_router/go_router.dart';
import 'package:kiru/presentation/pages/auth/login_screen.dart';
import 'package:kiru/presentation/pages/auth/signup_screen.dart';
import 'package:kiru/presentation/pages/onboarding/style_quiz_screen.dart';
import 'package:kiru/main.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const styleQuiz = '/style-quiz';
  // Home, Trips, etc later!

  static final router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: styleQuiz,
        builder: (context, state) => const StyleQuizScreen(),
      ),
    ],
  );
}
