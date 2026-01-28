import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class StockFilterChips extends StatefulWidget {
  final Function(String?) onFilterSelected;

  const StockFilterChips({
    super.key,
    required this.onFilterSelected,
  });

  @override
  State<StockFilterChips> createState() => _StockFilterChipsState();
}

class _StockFilterChipsState extends State<StockFilterChips> {
  String? _selectedFilter;

  @override
  void initState() {
    super.initState();
    _selectedFilter = 'All Alerts'; // Set default selection
    widget.onFilterSelected(_selectedFilter); // Notify parent of initial selection
  }

  final List<Map<String, dynamic>> _filters = [
    {
      'label': 'All Alerts',
      'icon': Icons.keyboard_arrow_down,
      'isPrimary': true,
    },
    {
      'label': 'Critical Only',
      'icon': Icons.warning,
      'isPrimary': false,
    },
    {
      'label': 'Low Only',
      'icon': Icons.warning_amber,
      'isPrimary': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter['label'];
            return Container(
              margin: const EdgeInsets.only(right: 12),
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    if (isSelected) {
                      // If clicking the currently selected chip, deselect it and select "All Alerts"
                      _selectedFilter = 'All Alerts';
                    } else {
                      // Select the clicked chip
                      _selectedFilter = filter['label'];
                    }
                  });
                  widget.onFilterSelected(_selectedFilter);
                },
                icon: Icon(
                  filter['icon'],
                  size: 20,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                ),
                label: Text(
                  filter['label'],
                  style: TextStyle(
                    fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackgroundLight),
                  foregroundColor: isSelected
                      ? Colors.white
                      : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                  side: isSelected
                      ? null
                      : BorderSide(
                          color: isDark ? AppColors.borderCardDark : AppColors.borderCardLight,
                        ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  elevation: isSelected ? 2 : 0,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
