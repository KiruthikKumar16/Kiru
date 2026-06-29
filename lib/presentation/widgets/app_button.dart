import 'package:flutter/material.dart';
import 'package:kiru/core/constants/app_spacing.dart';
import 'package:kiru/core/constants/app_colors.dart';

enum AppButtonType { primary, secondary, text }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isLoading;
  final double? height;
  final double? width;
  final Widget? icon;
  final bool isFullWidth;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.isLoading = false,
    this.height,
    this.width,
    this.icon,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: Size(
        isFullWidth ? double.infinity : width ?? 0,
        height ?? AppSpacing.buttonHeight,
      ),
      backgroundColor: _getBackgroundColor(),
      foregroundColor: _getForegroundColor(),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        side: _getBorderSide(),
      ),
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : width,
      height: height ?? AppSpacing.buttonHeight,
      child: type == AppButtonType.text
          ? TextButton(
              style: TextButton.styleFrom(
                minimumSize: Size(
                  isFullWidth ? double.infinity : width ?? 0,
                  height ?? AppSpacing.buttonHeight,
                ),
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                ),
              ),
              onPressed: isLoading ? null : onPressed,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : icon != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            icon!,
                            const SizedBox(width: AppSpacing.sm),
                            Text(text),
                          ],
                        )
                      : Text(text),
            )
          : ElevatedButton(
              style: buttonStyle,
              onPressed: isLoading ? null : onPressed,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : icon != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            icon!,
                            const SizedBox(width: AppSpacing.sm),
                            Text(text),
                          ],
                        )
                      : Text(text),
            ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case AppButtonType.primary:
        return AppColors.primary;
      case AppButtonType.secondary:
        return Colors.transparent;
      case AppButtonType.text:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor() {
    switch (type) {
      case AppButtonType.primary:
        return Colors.white;
      case AppButtonType.secondary:
      case AppButtonType.text:
        return AppColors.primary;
    }
  }

  BorderSide _getBorderSide() {
    switch (type) {
      case AppButtonType.secondary:
        return const BorderSide(color: AppColors.primary);
      case AppButtonType.primary:
      case AppButtonType.text:
        return BorderSide.none;
    }
  }
}
