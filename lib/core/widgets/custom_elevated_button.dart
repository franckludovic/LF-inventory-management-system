import 'package:flutter/material.dart';
import '../constants/colors.dart';

class CustomElevatedButton extends StatelessWidget {
  final String buttonName;
  final IconData buttonIcon;
  final VoidCallback onPressed;

  const CustomElevatedButton({
    super.key,
    required this.buttonName,
    required this.buttonIcon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(buttonIcon, size: 24),
          const SizedBox(width: 8),
          Text(
            buttonName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
