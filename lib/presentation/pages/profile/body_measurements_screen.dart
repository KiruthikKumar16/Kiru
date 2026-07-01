import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/presentation/widgets/app_button.dart';
import 'package:kiru/presentation/widgets/app_input_field.dart';
import 'package:kiru/data/models/user_profile.dart';
import 'package:kiru/presentation/providers/profile_provider.dart';

class BodyMeasurementsScreen extends ConsumerStatefulWidget {
  const BodyMeasurementsScreen({super.key});

  @override
  ConsumerState<BodyMeasurementsScreen> createState() => _BodyMeasurementsScreenState();
}

class _BodyMeasurementsScreenState extends ConsumerState<BodyMeasurementsScreen> {
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _chestController;
  late final TextEditingController _waistController;
  late final TextEditingController _hipsController;
  late final TextEditingController _inseamController;

  @override
  void initState() {
    super.initState();
    final measurements = ref.read(userProfileProvider)?.measurements ?? const BodyMeasurements();
    _heightController = TextEditingController(text: measurements.height > 0 ? measurements.height.toString() : '');
    _weightController = TextEditingController(text: measurements.weight > 0 ? measurements.weight.toString() : '');
    _chestController = TextEditingController(text: measurements.chest > 0 ? measurements.chest.toString() : '');
    _waistController = TextEditingController(text: measurements.waist > 0 ? measurements.waist.toString() : '');
    _hipsController = TextEditingController(text: measurements.hips > 0 ? measurements.hips.toString() : '');
    _inseamController = TextEditingController(text: measurements.inseam > 0 ? measurements.inseam.toString() : '');
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

  Future<void> _saveChanges() async {
    final measurements = BodyMeasurements(
      height: double.tryParse(_heightController.text) ?? 0,
      weight: double.tryParse(_weightController.text) ?? 0,
      chest: double.tryParse(_chestController.text) ?? 0,
      waist: double.tryParse(_waistController.text) ?? 0,
      hips: double.tryParse(_hipsController.text) ?? 0,
      inseam: double.tryParse(_inseamController.text) ?? 0,
    );
    await ref.read(userProfileProvider.notifier).updateProfile(measurements: measurements);
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Body Measurements', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppInputField(controller: _heightController, labelText: 'Height (cm)', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.md),
              AppInputField(controller: _weightController, labelText: 'Weight (kg)', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.md),
              AppInputField(controller: _chestController, labelText: 'Chest (cm)', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.md),
              AppInputField(controller: _waistController, labelText: 'Waist (cm)', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.md),
              AppInputField(controller: _hipsController, labelText: 'Hips (cm)', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.md),
              AppInputField(controller: _inseamController, labelText: 'Inseam (cm)', keyboardType: TextInputType.number),
              const SizedBox(height: AppSpacing.xl),
              AppButton(text: 'Save Changes', onPressed: _saveChanges),
            ],
          ),
        ),
      ),
    );
  }
}
