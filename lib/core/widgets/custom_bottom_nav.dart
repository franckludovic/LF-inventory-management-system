import 'package:flutter/material.dart';
import '../constants/colors.dart';

class NavItem {
  final IconData icon;
  final String label;
  final bool isSelected;

  const NavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
  });
}

class CustomBottomNav extends StatelessWidget {
  final List<NavItem> items;
  final ValueChanged<int> onItemSelected;
  final int currentIndex;

  const CustomBottomNav({
    super.key,
    required this.items,
    required this.onItemSelected,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.navBackgroundDark
            : AppColors.navBackgroundLight,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.navBorderDark : AppColors.navBorderLight,
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ColorFilter.mode(
            Colors.black.withOpacity(0.1),
            BlendMode.srcOver,
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isSelected = index == currentIndex;

                return GestureDetector(
                  onTap: () => onItemSelected(index),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        color: isSelected ? AppColors.primary : AppColors.textMutedDark,
                        size: 24,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          color: isSelected ? AppColors.primary : AppColors.textMutedDark,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
