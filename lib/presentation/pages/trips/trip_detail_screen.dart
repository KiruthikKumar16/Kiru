import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/presentation/providers/trip_provider.dart';
import 'package:kiru/presentation/widgets/app_button.dart';
import 'package:kiru/presentation/widgets/app_network_image.dart';
import 'package:intl/intl.dart';

class TripDetailScreen extends ConsumerStatefulWidget {
  final String tripId;

  const TripDetailScreen({super.key, required this.tripId});

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final trips = ref.watch(tripsProvider);
    final trip = trips.firstWhere((t) => t.id == widget.tripId, orElse: () => trips.first);
    final packedCount = trip.packingList.where((p) => p.isPacked).length;
    final packingProgress = ((packedCount / trip.packingList.length) * 100).round();
    const estimatedLuggageWeight = '7.5 kg';

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(trip.destination, style: const TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              tooltip: 'Share Trip',
              onPressed: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Share trip coming soon!')),
                );
              },
            ),
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
            isScrollable: true,
            tabs: [
              Tab(text: 'Overview'),
              Tab(text: 'Day-by-Day'),
              Tab(text: 'Packing'),
              Tab(text: 'Collaborate'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOverviewTab(trip, packedCount, packingProgress, estimatedLuggageWeight),
            _buildDayByDayTab(trip),
            _buildPackingTab(trip, packedCount, packingProgress),
            _buildCollaborateTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(dynamic trip, int packedCount, int packingProgress, String estimatedLuggageWeight) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: AppNetworkImage(
              imageUrl: trip.imageUrl,
              height: 200,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '${trip.destination}, ${trip.country}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                '${DateFormat('MMM d').format(trip.startDate)} - ${DateFormat('MMM d, yyyy').format(trip.endDate)}',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
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
          const Text('Quick Stats', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text(packingProgress.toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.primary)),
                      const SizedBox(height: 4),
                      const Text('% Packed', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      Text(estimatedLuggageWeight, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: AppColors.primary)),
                      const SizedBox(height: 4),
                      const Text('Est. Weight', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDayByDayTab(dynamic trip) {
    return ListView(
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
              date: trip.startDate.add(Duration(days: index)),
              outfit: outfitText,
            );
          }),
      ],
    );
  }

  Widget _buildPackingTab(dynamic trip, int packedCount, int packingProgress) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: trip.packingList.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Card(
              color: AppColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
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
                          '$packingProgress%',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: packingProgress / 100,
                        backgroundColor: AppColors.border,
                        color: AppColors.primary,
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        
        if (index == 1) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: AppButton(
              text: 'Add Item',
              type: AppButtonType.secondary,
              onPressed: () {
                HapticFeedback.lightImpact();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add packing item coming soon!')),
                );
              },
            ),
          );
        }

        final item = trip.packingList[index - 2];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: CheckboxListTile(
            tileColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              side: const BorderSide(color: AppColors.border),
            ),
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
          ),
        );
      },
    );
  }

  Widget _buildCollaborateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Invite Friends to Collaborate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: 'Invite Friends',
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invite friends coming soon!')),
              );
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          const Text('Current Collaborators', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: AppSpacing.md),
          ListTile(
            leading: const CircleAvatar(
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop'),
            ),
            title: const Text('Elena Rostova'),
            subtitle: const Text('Owner'),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          const Divider(),
          const SizedBox(height: AppSpacing.xl),
          const Text('Share Trip', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: AppSpacing.md),
          AppButton(
            text: 'Share Trip Link',
            type: AppButtonType.secondary,
            onPressed: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Share link coming soon!')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDayTile(BuildContext context, {required int dayNum, required DateTime date, required String outfit}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Day detail coming soon!')),
          );
        },
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
                    Text(
                      DateFormat('EEEE, MMM d').format(date),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(outfit, style: const TextStyle(fontSize: 14, color: AppColors.textPrimary, height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
