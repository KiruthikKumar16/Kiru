import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/presentation/widgets/app_button.dart';
import 'package:kiru/presentation/widgets/app_input_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'Elena Rostova');
  final _usernameController = TextEditingController(text: 'elena_travels');
  final _bioController = TextEditingController(text: 'Minimalist Adventurer • Exploring Mediterranean & Asia');

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold))),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=300&auto=format&fit=crop'),
              ),
              const SizedBox(height: AppSpacing.lg),
              AppInputField(controller: _nameController, labelText: 'Display Name'),
              const SizedBox(height: AppSpacing.md),
              AppInputField(controller: _usernameController, labelText: 'Username'),
              const SizedBox(height: AppSpacing.md),
              AppInputField(controller: _bioController, labelText: 'Bio / Travel Persona'),
              const SizedBox(height: AppSpacing.xl),
              AppButton(text: 'Save Changes', onPressed: () => context.pop()),
            ],
          ),
        ),
      ),
    );
  }
}
