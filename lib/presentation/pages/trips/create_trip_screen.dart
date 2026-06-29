import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/data/models/trip_model.dart';
import 'package:kiru/presentation/providers/app_mock_providers.dart';
import 'package:kiru/presentation/widgets/app_button.dart';
import 'package:kiru/presentation/widgets/app_input_field.dart';

class CreateTripScreen extends ConsumerStatefulWidget {
  const CreateTripScreen({super.key});

  @override
  ConsumerState<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends ConsumerState<CreateTripScreen> {
  final _destController = TextEditingController();
  final _countryController = TextEditingController();
  final _occasionController = TextEditingController();
  bool _isPrivate = true;

  @override
  void dispose() {
    _destController.dispose();
    _countryController.dispose();
    _occasionController.dispose();
    super.dispose();
  }

  void _saveTrip() {
    if (_destController.text.isEmpty) return;

    final newTrip = TripModel(
      id: 't_${DateTime.now().millisecondsSinceEpoch}',
      destination: _destController.text,
      country: _countryController.text.isEmpty ? 'Global' : _countryController.text,
      imageUrl: 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop',
      startDate: DateTime.now().add(const Duration(days: 7)),
      endDate: DateTime.now().add(const Duration(days: 14)),
      occasion: _occasionController.text.isEmpty ? 'Vacation' : _occasionController.text,
      weatherTemp: '24°C',
      weatherCondition: 'Sunny',
      isPrivate: _isPrivate,
      packingList: const [
        PackingListItem(id: 'np1', title: 'Essential Shirts', category: 'Clothing', isPacked: false),
        PackingListItem(id: 'np2', title: 'Comfortable Sneakers', category: 'Footwear', isPacked: false),
      ],
    );

    ref.read(tripsProvider.notifier).addTrip(newTrip);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan New Trip', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInputField(
                controller: _destController,
                labelText: 'Destination City',
                hintText: 'e.g. Paris, Tokyo, New York',
              ),
              const SizedBox(height: AppSpacing.lg),
              AppInputField(
                controller: _countryController,
                labelText: 'Country',
                hintText: 'e.g. France, Japan',
              ),
              const SizedBox(height: AppSpacing.lg),
              AppInputField(
                controller: _occasionController,
                labelText: 'Travel Occasion',
                hintText: 'e.g. Business Conference, Beach Resort, Wedding',
              ),
              const SizedBox(height: AppSpacing.xl),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Private Trip (Security Standard)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Hides exact travel dates and location from public feed.'),
                value: _isPrivate,
                activeColor: AppColors.primary,
                onChanged: (val) => setState(() => _isPrivate = val),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                text: 'Generate AI Outfit Recommendations',
                onPressed: _saveTrip,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
