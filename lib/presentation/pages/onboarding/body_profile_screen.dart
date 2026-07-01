import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:kiru/core/routes/app_routes.dart';
import 'package:kiru/data/models/user_profile.dart';
import 'package:kiru/presentation/providers/profile_provider.dart';
import 'package:kiru/presentation/widgets/app_button.dart';

class BodyProfileScreen extends ConsumerStatefulWidget {
  const BodyProfileScreen({super.key});

  @override
  ConsumerState<BodyProfileScreen> createState() => _BodyProfileScreenState();
}

class _BodyProfileScreenState extends ConsumerState<BodyProfileScreen> {
  String _selectedBodyType = 'Hourglass';
  bool _isLoading = false;
  bool _hasDetected = false;

  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _chestController = TextEditingController();
  final TextEditingController _waistController = TextEditingController();
  final TextEditingController _hipsController = TextEditingController();
  final TextEditingController _inseamController = TextEditingController();

  final List<Map<String, String>> _bodyTypes = [
    {'name': 'Hourglass', 'description': 'Balanced bust and hips with a defined waist'},
    {'name': 'Athletic', 'description': 'Uniform width across shoulders and hips'},
    {'name': 'Pear', 'description': 'Hips wider than shoulders and bust'},
    {'name': 'Apple', 'description': 'Fuller midsection with slender legs'},
    {'name': 'Rectangle', 'description': 'Straight silhouette with athletic proportions'},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profile = ref.read(userProfileProvider);
      if (profile != null) {
        if (profile.bodyShape.isNotEmpty) {
          setState(() => _selectedBodyType = profile.bodyShape);
        }
        _heightController.text = profile.measurements.height > 0 ? profile.measurements.height.toString() : '';
        _weightController.text = profile.measurements.weight > 0 ? profile.measurements.weight.toString() : '';
        _chestController.text = profile.measurements.chest > 0 ? profile.measurements.chest.toString() : '';
        _waistController.text = profile.measurements.waist > 0 ? profile.measurements.waist.toString() : '';
        _hipsController.text = profile.measurements.hips > 0 ? profile.measurements.hips.toString() : '';
        _inseamController.text = profile.measurements.inseam > 0 ? profile.measurements.inseam.toString() : '';
      }
    });
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _hipsController.dispose();
    _inseamController.dispose();
    super.dispose();
  }

  Future<void> _detectWithCV() async {
    setState(() => _isLoading = true);

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        await Future.delayed(const Duration(seconds: 2));

        setState(() {
          _heightController.text = '165';
          _weightController.text = '60';
          _chestController.text = '90';
          _waistController.text = '65';
          _hipsController.text = '95';
          _inseamController.text = '80';
          _selectedBodyType = 'Hourglass';
          _hasDetected = true;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveAndContinue() async {
    final measurements = BodyMeasurements(
      height: double.tryParse(_heightController.text) ?? 0,
      weight: double.tryParse(_weightController.text) ?? 0,
      chest: double.tryParse(_chestController.text) ?? 0,
      waist: double.tryParse(_waistController.text) ?? 0,
      hips: double.tryParse(_hipsController.text) ?? 0,
      inseam: double.tryParse(_inseamController.text) ?? 0,
    );

    await ref.read(userProfileProvider.notifier).updateProfile(
          bodyShape: _selectedBodyType,
          measurements: measurements,
        );

    if (mounted) context.go(AppRoutes.skinTone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  Text(
                    'Body Profile',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: _saveAndContinue,
                    child: const Text('Skip'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Get personalized outfit recommendations that fit perfectly',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCVSection(),
                      const SizedBox(height: AppSpacing.lg),
                      _buildBodyTypeSection(),
                      const SizedBox(height: AppSpacing.lg),
                      _buildMeasurementsSection(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                text: 'Continue',
                onPressed: _saveAndContinue,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCVSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(Icons.photo_camera, size: 48, color: AppColors.primary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _hasDetected ? 'Detection Complete!' : 'Auto-Detect Measurements',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _hasDetected
                ? 'You can edit the detected values below'
                : 'Take a photo for quick measurements (CV placeholder)',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          if (!_hasDetected)
            AppButton(
              text: 'Take Photo',
              onPressed: _detectWithCV,
              isLoading: _isLoading,
            ),
        ],
      ),
    );
  }

  Widget _buildBodyTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Body Type',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        ..._bodyTypes.map((type) {
          final isSelected = _selectedBodyType == type['name'];
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: GestureDetector(
              onTap: () => setState(() => _selectedBodyType = type['name']!),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withValues(alpha: 0.08) : AppColors.surface,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            type['name']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            type['description']!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMeasurementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Manual Measurements',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildMeasurementField('Height', 'cm', _heightController),
        const SizedBox(height: AppSpacing.sm),
        _buildMeasurementField('Weight', 'kg', _weightController),
        const SizedBox(height: AppSpacing.sm),
        _buildMeasurementField('Chest', 'cm', _chestController),
        const SizedBox(height: AppSpacing.sm),
        _buildMeasurementField('Waist', 'cm', _waistController),
        const SizedBox(height: AppSpacing.sm),
        _buildMeasurementField('Hips', 'cm', _hipsController),
        const SizedBox(height: AppSpacing.sm),
        _buildMeasurementField('Inseam', 'cm', _inseamController),
      ],
    );
  }

  Widget _buildMeasurementField(String label, String unit, TextEditingController controller) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              suffixText: unit,
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: const BorderSide(color: AppColors.border),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
            ),
          ),
        ),
      ],
    );
  }
}
