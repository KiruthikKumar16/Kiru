import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiru/core/theme/app_theme.dart';

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.light);

final themeProvider = Provider<ThemeData>((ref) {
  final themeMode = ref.watch(themeModeProvider);
  switch (themeMode) {
    case ThemeMode.dark:
      // TODO: Add dark theme later
      return AppTheme.lightTheme;
    case ThemeMode.light:
    case ThemeMode.system:
      return AppTheme.lightTheme;
  }
});
