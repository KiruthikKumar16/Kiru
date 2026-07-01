import 'package:flutter/material.dart';
import 'package:kiru/core/constants/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget? errorWidget;
  final Widget? placeholder;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorWidget,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) => placeholder ??
          Container(
            color: AppColors.surface,
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
      errorWidget: (context, url, error) => errorWidget ??
          Container(
            color: AppColors.surface,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 48, color: AppColors.textSecondary),
                ],
              ),
            ),
          ),
    );
  }
}
