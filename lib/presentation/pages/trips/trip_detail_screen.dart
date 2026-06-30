import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/presentation/providers/trip_provider.dart';

class TripDetailScreen extends ConsumerWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trips = ref.watch(tripsProvider);
    final trip = trips.firstWhere((t) => t.id == tripId, orElse: () => trips.first);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(trip.destination, style: const TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Itinerary'),
                    content: const Text('Are you sure you want to delete this trip?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete', style: TextStyle(color: AppColors.error)),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ref.read(tripsProvider.notifier).deleteTrip(trip.id);
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'Day-by-Day Outfits'),
              Tab(text: 'Packing Checklist'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.wb_cloudy_outlined, color: AppColors.primary, size: 30),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${trip.weatherCondition} • ${trip.weatherTemp}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const Text('Auto-adjusted recommendations based on live forecast.', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                if (trip.dailyOutfits.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40.0),
                    child: Center(
                      child: Text('No daily outfits generated yet.', style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  )
                else
                  ...trip.dailyOutfits.asMap().entries.map((entry) {
                    final index = entry.key;
                    final outfitText = entry.value;

                    return _buildDayTile(
                      context,
                      dayNum: index + 1,
                      outfit: outfitText,
                    );
                  }),
              ],
            ),
            ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.lg),
              itemCount: trip.packingList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  final packedCount = trip.packingList.where((p) => p.isPacked).length;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: Card(
                      color: AppColors.surface,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Luggage Progress', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                const SizedBox(height: 4),
                                Text(
                                  '$packedCount of ${trip.packingList.length} items packed',
                                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                                ),
                              ],
                            ),
                            Text(
                              '${((packedCount / trip.packingList.length) * 100).round()}%',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final item = trip.packingList[index - 1];
                return CheckboxListTile(
                  title: Text(
                    item.title,
                    style: TextStyle(decoration: item.isPacked ? TextDecoration.lineThrough : null),
                  ),
                  subtitle: Text(item.category, style: const TextStyle(fontSize: 12)),
                  value: item.isPacked,
                  activeColor: AppColors.primary,
                  onChanged: (_) {
                    ref.read(tripsProvider.notifier).togglePackingItem(trip.id, item.id);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayTile(BuildContext context, {required int dayNum, required String outfit}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.15),
              child: Text('$dayNum', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(outfit, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.4)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
