import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/routes/app_routes.dart';
import 'package:kiru/presentation/providers/trip_provider.dart';
import 'package:intl/intl.dart';

enum TripFilter { upcoming, past, all }

class TripsScreen extends ConsumerStatefulWidget {
  const TripsScreen({super.key});

  @override
  ConsumerState<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends ConsumerState<TripsScreen> {
  TripFilter _selectedFilter = TripFilter.upcoming;

  @override
  Widget build(BuildContext context) {
    final trips = ref.watch(tripsProvider);
    final now = DateTime.now();
    List filteredTrips;

    switch (_selectedFilter) {
      case TripFilter.upcoming:
        filteredTrips = trips.where((t) => t.startDate.isAfter(now)).toList();
        break;
      case TripFilter.past:
        filteredTrips = trips.where((t) => t.startDate.isBefore(now)).toList();
        break;
      case TripFilter.all:
        filteredTrips = trips;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Travel Itineraries', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 28),
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push(AppRoutes.createTrip);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 8),
            child: SegmentedButton<TripFilter>(
              segments: const [
                ButtonSegment(
                  value: TripFilter.upcoming,
                  label: Text('Upcoming'),
                ),
                ButtonSegment(
                  value: TripFilter.past,
                  label: Text('Past'),
                ),
                ButtonSegment(
                  value: TripFilter.all,
                  label: Text('All'),
                ),
              ],
              selected: {_selectedFilter},
              onSelectionChanged: (Set<TripFilter> newSelection) {
                HapticFeedback.lightImpact();
                setState(() {
                  _selectedFilter = newSelection.first;
                });
              },
              style: SegmentedButton.styleFrom(
                selectedBackgroundColor: AppColors.primary,
                selectedForegroundColor: Colors.white,
                foregroundColor: AppColors.textPrimary,
                backgroundColor: AppColors.surface,
                side: BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: filteredTrips.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.card_travel_outlined, size: 80, color: AppColors.primary.withValues(alpha: 0.5)),
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        _selectedFilter == TripFilter.upcoming
                            ? 'No upcoming trips yet'
                            : _selectedFilter == TripFilter.past
                                ? 'No past trips'
                                : 'No trips yet',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ElevatedButton.icon(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          context.push(AppRoutes.createTrip);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Plan a Trip'),
                      ),
                    ],
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: filteredTrips.length,
                itemBuilder: (context, index) {
                  final trip = filteredTrips[index];
                  final dateStr = trip.hideDates
                      ? 'Dates Hidden (Private)'
                      : '${DateFormat('MMM d').format(trip.startDate)} - ${DateFormat('MMM d, yyyy').format(trip.endDate)}';
                  final destStr = trip.hideLocation
                      ? 'Hidden Location, ${trip.country}'
                      : '${trip.destination}, ${trip.country}';

                  final tripDuration = trip.endDate.difference(trip.startDate).inDays + 1;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                    child: InkWell(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        context.push('/trips/${trip.id}');
                      },
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusXl)),
                              child: Image.network(
                                trip.imageUrl,
                                height: 160,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                destStr,
                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            if (trip.isPrivate) ...[
                                              const SizedBox(width: 6),
                                              const Icon(Icons.lock_outline, size: 16, color: AppColors.primary),
                                            ],
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          trip.weatherTemp,
                                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 14, color: AppColors.textSecondary),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(dateStr, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: AppColors.border),
                                        ),
                                        child: Text(
                                          '$tripDuration days',
                                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.w500),
                                        ),
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
                  );
                },
              ),
      ),
    );
  }
}
