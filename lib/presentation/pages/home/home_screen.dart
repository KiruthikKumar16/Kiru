import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/routes/app_routes.dart';
import 'package:kiru/presentation/providers/profile_provider.dart';
import 'package:kiru/presentation/providers/trip_provider.dart';
import 'package:kiru/presentation/providers/app_mock_providers.dart';
import 'package:kiru/presentation/widgets/app_network_image.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  Future<void> _onRefresh() async {
    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final trips = ref.watch(tripsProvider);
    final now = DateTime.now();
    final upcomingTrips = trips.where((t) => t.startDate.isAfter(now)).toList();
    final pastTrips = trips.where((t) => t.startDate.isBefore(now)).toList();
    final upcomingTrip = upcomingTrips.isNotEmpty ? upcomingTrips.first : null;
    final profile = ref.watch(userProfileProvider);
    final firstName = profile?.displayName.split(' ').first ?? 'Traveler';
    final inspirations = ref.watch(inspirationProvider);
    final dynamicSubtitle = ref.watch(dynamicSubtitleProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.push(AppRoutes.createTrip);
          },
        ),
        title: const Text('Kiru', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push(AppRoutes.profile);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        color: AppColors.primary,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome header
                Text(
                  'Hello, $firstName!',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  dynamicSubtitle,
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.xl),

                // Trip Inspiration Carousel
                if (inspirations.isNotEmpty) ...[
                  Text(
                    'Trip Inspiration',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      itemCount: inspirations.length,
                      separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final inspiration = inspirations[index];
                        return Container(
                          width: 280,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AppNetworkImage(
                                    imageUrl: inspiration.imageUrl,
                                    width: 80,
                                    height: double.infinity,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        inspiration.title,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        inspiration.description,
                                        style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],

                // Upcoming Trip Preview Card
                if (upcomingTrip != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Upcoming Trip',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      InkWell(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          context.go(AppRoutes.trips);
                        },
                        child: const Text('View All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  InkWell(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      context.push('/trips/${upcomingTrip.id}');
                    },
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                            child: AppNetworkImage(
                              imageUrl: upcomingTrip.imageUrl,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.wb_sunny_outlined, size: 14, color: Colors.orange),
                                        const SizedBox(width: 4),
                                        Text(
                                          upcomingTrip.weatherTemp,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${upcomingTrip.destination}, ${upcomingTrip.country}',
                                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      'Occasion: ${upcomingTrip.occasion}',
                                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],

                // Past Trips Section (horizontal)
                if (pastTrips.isNotEmpty) ...[
                  Text(
                    'Past Trips',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 120,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      itemCount: pastTrips.length,
                      separatorBuilder: (context, index) => const SizedBox(width: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final trip = pastTrips[index];
                        return InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            context.push('/trips/${trip.id}');
                          },
                          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                          child: Container(
                            width: 220,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: AppNetworkImage(
                                      imageUrl: trip.imageUrl,
                                    ),
                                  ),
                                  Positioned.fill(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: AppSpacing.md,
                                    right: AppSpacing.md,
                                    bottom: AppSpacing.md,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          trip.destination,
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        Text(
                                          trip.country,
                                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
