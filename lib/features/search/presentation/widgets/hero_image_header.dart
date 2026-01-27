import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class HeroImageHeader extends StatelessWidget {
  final String imageUrl;

  const HeroImageHeader({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
          ),
          child: imageUrl.isNotEmpty && Uri.tryParse(imageUrl)?.hasScheme == true
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildPlaceholder(isDark),
                  ),
                )
              : _buildPlaceholder(isDark),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(bool isDark) {
    return Center(
      child: Icon(
        Icons.inventory_2_outlined,
        size: 64,
        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
      ),
    );
  }
}
