import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:kiru/core/constants/app_strings.dart';
import 'package:kiru/core/routes/app_routes.dart';
import 'package:kiru/presentation/providers/theme_provider.dart';
import 'package:kiru/core/security/encryption_helper.dart';
import 'package:kiru/data/models/trip_model.dart';
import 'package:kiru/data/models/wardrobe_item.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.openBox('settings');

  // Initialize encrypted box for wardrobe
  final cipher = await EncryptionHelper.getEncryptionCipher();
  Hive.registerAdapter(WardrobeItemAdapter());
  Hive.registerAdapter(PackingListItemAdapter());
  Hive.registerAdapter(TripModelAdapter());
  await Hive.openBox<WardrobeItem>('wardrobe_items', encryptionCipher: cipher);
  await Hive.openBox<TripModel>('trips', encryptionCipher: cipher);

  runApp(const ProviderScope(child: KiruApp()));
}

class KiruApp extends ConsumerWidget {
  const KiruApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: theme,
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF6366F1),
          secondary: const Color(0xFFEC4899),
          surface: const Color(0xFF1E1E1E),
          error: const Color(0xFFEF4444),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      themeMode: themeMode,
      routerConfig: AppRoutes.router,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        context.go(AppRoutes.welcome);
        return;
      }
      final box = Hive.box('settings');
      final hasCompleted = box.get('onboarding_completed_${user.uid}', defaultValue: false) as bool;
      context.go(hasCompleted ? AppRoutes.home : AppRoutes.styleQuiz);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppStrings.appName,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.appTagline,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
