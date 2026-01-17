import 'package:flutter/material.dart';
import '../constants/strings.dart';
import '../theme/app_theme.dart';

class PartActionsWidget extends StatelessWidget {
  const PartActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implement update stock functionality
              },
              icon: const Icon(Icons.edit_square),
              label: Text(AppStrings.updateStock),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO: Implement add/replace image functionality
              },
              icon: const Icon(Icons.add_a_photo),
              label: Text(AppStrings.addReplaceImage),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.borderColor),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
