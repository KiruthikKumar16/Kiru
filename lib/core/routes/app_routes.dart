import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:kiru/core/routes/auth_refresh_notifier.dart';
import 'package:kiru/main.dart';
import 'package:kiru/presentation/pages/auth/welcome_screen.dart';
import 'package:kiru/presentation/pages/auth/login_screen.dart';
import 'package:kiru/presentation/pages/auth/signup_screen.dart';
import 'package:kiru/presentation/pages/onboarding/welcome_onboarding_screen.dart';
import 'package:kiru/presentation/pages/onboarding/style_quiz_screen.dart';
import 'package:kiru/presentation/pages/onboarding/body_profile_screen.dart';
import 'package:kiru/presentation/pages/onboarding/skin_tone_screen.dart';
import 'package:kiru/presentation/pages/onboarding/wardrobe_setup_screen.dart';
import 'package:kiru/presentation/pages/home/home_screen.dart';
import 'package:kiru/presentation/pages/feed/feed_screen.dart';
import 'package:kiru/presentation/pages/feed/discover_screen.dart';
import 'package:kiru/presentation/pages/feed/post_detail_screen.dart';
import 'package:kiru/presentation/pages/feed/create_post_screen.dart';
import 'package:kiru/presentation/pages/social/notifications_screen.dart';
import 'package:kiru/presentation/pages/social/messages_screen.dart';
import 'package:kiru/presentation/pages/social/chat_detail_screen.dart';
import 'package:kiru/presentation/pages/trips/trips_screen.dart';
import 'package:kiru/presentation/pages/trips/trip_detail_screen.dart';
import 'package:kiru/presentation/pages/trips/create_trip_screen.dart';
import 'package:kiru/presentation/pages/wardrobe/add_wardrobe_item_screen.dart';
import 'package:kiru/presentation/pages/wardrobe/wardrobe_item_detail_screen.dart';
import 'package:kiru/presentation/pages/wardrobe/wardrobe_analytics_screen.dart';
import 'package:kiru/presentation/pages/wardrobe/loaned_items_screen.dart';
import 'package:kiru/presentation/pages/ai_stylist/ai_stylist_screen.dart';
import 'package:kiru/presentation/pages/ai_stylist/recommendation_detail_screen.dart';

import 'package:kiru/presentation/pages/profile/profile_screen.dart';
import 'package:kiru/presentation/pages/profile/public_profile_screen.dart';
import 'package:kiru/presentation/pages/profile/edit_profile_screen.dart';
import 'package:kiru/presentation/pages/profile/privacy_settings_screen.dart';
import 'package:kiru/presentation/pages/profile/user_profile_screen.dart';
import 'package:kiru/presentation/pages/profile/followers_list_screen.dart';
import 'package:kiru/presentation/pages/profile/following_list_screen.dart';
import 'package:kiru/presentation/pages/profile/my_posts_screen.dart';
import 'package:kiru/presentation/pages/profile/saved_posts_screen.dart';
import 'package:kiru/presentation/pages/profile/saved_outfits_screen.dart';
import 'package:kiru/presentation/pages/profile/style_preferences_screen.dart';
import 'package:kiru/presentation/pages/profile/body_measurements_screen.dart';
import 'package:kiru/presentation/pages/profile/settings_screen.dart';
import 'package:kiru/presentation/pages/profile/premium_subscription_screen.dart';
import 'package:kiru/presentation/pages/profile/help_support_screen.dart';
import 'package:kiru/presentation/widgets/scaffold_with_navbar.dart';

class AppRoutes {
  static const splash = '/';
  static const welcome = '/welcome';
  static const login = '/login';
  static const signup = '/signup';
  static const onboardingWelcome = '/onboarding/welcome';
  static const styleQuiz = '/onboarding/style-quiz';
  static const bodyProfile = '/onboarding/body-profile';
  static const skinTone = '/onboarding/skin-tone';
  static const wardrobeSetup = '/onboarding/wardrobe-setup';

  static const home = '/home';
  static const feed = '/feed';
  static const discover = '/feed/discover';
  static const createPost = '/feed/create';
  static const notifications = '/notifications';
  static const messages = '/messages';

  static const trips = '/trips';
  static const createTrip = '/trips/create';

  static const wardrobe = '/wardrobe';
  static const addWardrobe = '/wardrobe/add';
  static const wardrobeAnalytics = '/wardrobe/analytics';
  static const loanedItems = '/wardrobe/loaned';

  static const stylist = '/stylist';
  static const recommendationDetail = '/stylist/recommendation';

  static const profile = '/profile';
  static const publicProfile = '/profile/public';
  static const editProfile = '/profile/edit';
  static const privacySettings = '/profile/privacy';
  static const followersList = '/profile/followers';
  static const followingList = '/profile/following';
  static const myPosts = '/profile/my-posts';
  static const savedPosts = '/profile/saved';
  static const savedOutfits = '/profile/saved-outfits';
  static const stylePreferences = '/profile/style-preferences';
  static const bodyMeasurements = '/profile/body-measurements';
  static const settings = '/profile/settings';
  static const premiumSubscription = '/profile/premium';
  static const helpSupport = '/profile/help';

  static final _authRefresh = AuthRefreshNotifier();

  static final router = GoRouter(
    initialLocation: splash,
    refreshListenable: _authRefresh,
    redirect: (context, state) {
      final user = FirebaseAuth.instance.currentUser;
      final loggedIn = user != null;
      final loggingIn = state.matchedLocation == login ||
          state.matchedLocation == signup ||
          state.matchedLocation == welcome ||
          state.matchedLocation == splash;

      if (!loggedIn) {
        return loggingIn ? null : welcome;
      }

      final box = Hive.box('settings');
      final hasCompletedOnboarding = box.get('onboarding_completed_${user.uid}', defaultValue: false) as bool;

      if (!hasCompletedOnboarding) {
        final isOnboarding = state.matchedLocation == onboardingWelcome ||
            state.matchedLocation == styleQuiz ||
            state.matchedLocation == bodyProfile ||
            state.matchedLocation == skinTone ||
            state.matchedLocation == wardrobeSetup;
        return isOnboarding ? null : onboardingWelcome;
      }

      if (loggingIn ||
          state.matchedLocation == onboardingWelcome ||
          state.matchedLocation == styleQuiz ||
          state.matchedLocation == bodyProfile ||
          state.matchedLocation == skinTone ||
          state.matchedLocation == wardrobeSetup) {
        return home;
      }

      return null;
    },
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(path: welcome, builder: (context, state) => const WelcomeScreen()),
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),
      GoRoute(path: signup, builder: (context, state) => const SignupScreen()),
      GoRoute(path: onboardingWelcome, builder: (context, state) => const WelcomeOnboardingScreen()),
      GoRoute(path: styleQuiz, builder: (context, state) => const StyleQuizScreen()),
      GoRoute(path: bodyProfile, builder: (context, state) => const BodyProfileScreen()),
      GoRoute(path: skinTone, builder: (context, state) => const SkinToneScreen()),
      GoRoute(path: wardrobeSetup, builder: (context, state) => const WardrobeSetupScreen()),
      GoRoute(path: createTrip, builder: (context, state) => const CreateTripScreen()),
      GoRoute(path: addWardrobe, builder: (context, state) => const AddWardrobeItemScreen()),
      GoRoute(path: wardrobeAnalytics, builder: (context, state) => const WardrobeAnalyticsScreen()),
      GoRoute(path: loanedItems, builder: (context, state) => const LoanedItemsScreen()),
      GoRoute(path: discover, builder: (context, state) => const DiscoverScreen()),
      GoRoute(path: createPost, builder: (context, state) => const CreatePostScreen()),
      GoRoute(path: notifications, builder: (context, state) => const NotificationsScreen()),
      GoRoute(path: messages, builder: (context, state) => const MessagesScreen()),
      GoRoute(path: publicProfile, builder: (context, state) => const PublicProfileScreen()),
      GoRoute(path: recommendationDetail, builder: (context, state) => const RecommendationDetailScreen()),
      GoRoute(path: editProfile, builder: (context, state) => const EditProfileScreen()),
      GoRoute(path: privacySettings, builder: (context, state) => const PrivacySettingsScreen()),
      GoRoute(path: followersList, builder: (context, state) => const FollowersListScreen()),
      GoRoute(path: followingList, builder: (context, state) => const FollowingListScreen()),
      GoRoute(path: myPosts, builder: (context, state) => const MyPostsScreen()),
      GoRoute(path: savedPosts, builder: (context, state) => const SavedPostsScreen()),
      GoRoute(path: savedOutfits, builder: (context, state) => const SavedOutfitsScreen()),
      GoRoute(path: stylePreferences, builder: (context, state) => const StylePreferencesScreen()),
      GoRoute(path: bodyMeasurements, builder: (context, state) => const BodyMeasurementsScreen()),
      GoRoute(path: settings, builder: (context, state) => const SettingsScreen()),
      GoRoute(path: premiumSubscription, builder: (context, state) => const PremiumSubscriptionScreen()),
      GoRoute(path: helpSupport, builder: (context, state) => const HelpSupportScreen()),

      GoRoute(
        path: '/trips/:id',
        builder: (context, state) => TripDetailScreen(tripId: state.pathParameters['id'] ?? 't1'),
      ),
      GoRoute(
        path: '/wardrobe/:id',
        builder: (context, state) => WardrobeItemDetailScreen(itemId: state.pathParameters['id'] ?? 'w1'),
      ),
      GoRoute(
        path: '/post/:id',
        builder: (context, state) => PostDetailScreen(postId: state.pathParameters['id'] ?? 'sp1'),
      ),
      GoRoute(
        path: '/messages/:id',
        builder: (context, state) => ChatDetailScreen(chatId: state.pathParameters['id'] ?? 'c1'),
      ),
      GoRoute(
        path: '/user/:id',
        builder: (context, state) => UserProfileScreen(userId: state.pathParameters['id'] ?? 'u1'),
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: trips, builder: (context, state) => const TripsScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: feed, builder: (context, state) => const FeedScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: home, builder: (context, state) => const HomeScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: stylist, builder: (context, state) => const AiStylistScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: profile, builder: (context, state) => const ProfileScreen())],
          ),
        ],
      ),
    ],
  );
}
