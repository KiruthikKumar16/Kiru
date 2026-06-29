import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/presentation/providers/app_mock_providers.dart';

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
            // Day by day timeline view
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
                _buildDayTile(context, dayNum: 1, title: 'Day 1: Arrival & Temple Exploration', outfit: 'Linen Vacation Shirt + Chino Trousers'),
                _buildDayTile(context, dayNum: 2, title: 'Day 2: Cultural Walking Tour', outfit: 'Classic Denim Jacket + Canvas Sneakers'),
                _buildDayTile(context, dayNum: 3, title: 'Day 3: Sunset Dinner & Drinks', outfit: 'Floral Midi Dress / Tailored Blazer'),
              ],
            ),

            // Interactive Packing List
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
                                Text('$packedCount of ${trip.packingList.length} items packed', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                              ],
                            ),
                            const Text('Estimated: 14.2 kg', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                final item = trip.packingList[index - 1];
                return CheckboxListTile(
                  title: Text(item.title, style: TextStyle(decoration: item.isPacked ? TextDecoration.lineThrough : null)),
                  subtitle: Text(item.category, style: const TextStyle(fontSize: 12)),
                  value: item.isPacked,
                  activeColor: AppColors.primary,
                  onChanged: (val) {
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

  Widget _buildDayTile(BuildContext context, {required int dayNum, required String title, required String outfit}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.checkroom, size: 18, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(child: Text(outfit, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
