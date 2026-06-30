import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/data/datasources/weather_api.dart';
import 'package:kiru/data/models/trip_model.dart';
import 'package:kiru/presentation/providers/trip_provider.dart';
import 'package:kiru/presentation/providers/profile_provider.dart';
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
  bool _hideDates = true;
  bool _hideLocation = true;
  bool _isLoading = false;

  DateTime _startDate = DateTime.now().add(const Duration(days: 7));
  DateTime _endDate = DateTime.now().add(const Duration(days: 14));
  String? _weatherTemp;
  String? _weatherCondition;

  @override
  void dispose() {
    _destController.dispose();
    _countryController.dispose();
    _occasionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isStart}) async {
    final initial = isStart ? _startDate : _endDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate.isBefore(_startDate)) {
            _endDate = _startDate.add(const Duration(days: 7));
          }
        } else {
          _endDate = picked.isBefore(_startDate) ? _startDate : picked;
        }
      });
    }
  }

  Future<void> _fetchWeather() async {
    if (_destController.text.trim().isEmpty) return;
    try {
      final days = _endDate.difference(_startDate).inDays + 1;
      final weatherService = WeatherService();
      final forecast = await weatherService.getForecast(
        _destController.text.trim(),
        _countryController.text.trim(),
        days.clamp(1, 5),
      );
      setState(() {
        _weatherTemp = forecast.temp;
        _weatherCondition = forecast.condition;
      });
    } catch (_) {}
  }

  Future<void> _saveTrip() async {
    if (_destController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a destination')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _fetchWeather();

      final tripId = 't_${DateTime.now().millisecondsSinceEpoch}';
      final newTrip = TripModel(
        id: tripId,
        destination: _destController.text.trim(),
        country: _countryController.text.trim().isEmpty ? 'Global' : _countryController.text.trim(),
        imageUrl: _destinationImage(_destController.text.trim()),
        startDate: _startDate,
        endDate: _endDate,
        occasion: _occasionController.text.trim().isEmpty ? 'Vacation' : _occasionController.text.trim(),
        weatherTemp: _weatherTemp ?? '24°C',
        weatherCondition: _weatherCondition ?? 'Sunny',
        isPrivate: _isPrivate,
        hideDates: _hideDates,
        hideLocation: _hideLocation,
        packingList: [
          PackingListItem(id: 'np1', title: 'Essential Shirts', category: 'Clothing'),
          PackingListItem(id: 'np2', title: 'Comfortable Sneakers', category: 'Footwear'),
          PackingListItem(id: 'np3', title: 'Travel Adapter', category: 'Electronics'),
          PackingListItem(id: 'np4', title: 'Passport & Documents', category: 'Documents'),
        ],
        dailyOutfits: [], // Generates during notifier addTrip call
      );

      final profile = ref.read(userProfileProvider);
      final wardrobe = ref.read(wardrobeItemsProvider);

      await ref.read(tripsProvider.notifier).addTrip(
            newTrip,
            wardrobe: wardrobe,
            profile: profile,
          );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving trip: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _destinationImage(String destination) {
    final lower = destination.toLowerCase();
    if (lower.contains('tokyo') || lower.contains('japan')) {
      return 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800&auto=format&fit=crop';
    }
    if (lower.contains('santorini') || lower.contains('greece')) {
      return 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=800&auto=format&fit=crop';
    }
    if (lower.contains('bali')) {
      return 'https://images.unsplash.com/photo-1537996194471-d29704cb59c8?w=800&auto=format&fit=crop';
    }
    if (lower.contains('paris')) {
      return 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800&auto=format&fit=crop';
    }
    return 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=800&auto=format&fit=crop';
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');

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
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickDate(isStart: true),
                      icon: const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                      label: Text('Start: ${dateFormat.format(_startDate)}'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickDate(isStart: false),
                      icon: const Icon(Icons.event, size: 18, color: AppColors.primary),
                      label: Text('End: ${dateFormat.format(_endDate)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Private Trip (Default)', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('Hides this trip from all social/feed lookups.'),
                value: _isPrivate,
                activeThumbColor: AppColors.primary,
                onChanged: (val) => setState(() => _isPrivate = val),
              ),
              const Divider(),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Hide Travel Dates'),
                subtitle: const Text('Hides specific dates from other users in public posts.'),
                value: _hideDates,
                activeThumbColor: AppColors.primary,
                onChanged: (val) => setState(() => _hideDates = val),
              ),
              const Divider(),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Hide Location Details'),
                subtitle: const Text('Masks exact city names on your public itineraries.'),
                value: _hideLocation,
                activeThumbColor: AppColors.primary,
                onChanged: (val) => setState(() => _hideLocation = val),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                text: 'Generate AI Outfit Recommendations',
                onPressed: _saveTrip,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
