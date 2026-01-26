import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum SnackbarType {
  success,
  error,
  warning,
  info,
}

class SnackbarUtils {
  static void show({
    required String title,
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 3),
  }) {
    Color backgroundColor;
    Color textColor = Colors.white;
    IconData? icon;

    switch (type) {
      case SnackbarType.success:
        backgroundColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case SnackbarType.error:
        backgroundColor = Colors.red;
        icon = Icons.error;
        break;
      case SnackbarType.warning:
        backgroundColor = Colors.orange;
        icon = Icons.warning;
        break;
      case SnackbarType.info:
        backgroundColor = Colors.blue;
        icon = Icons.info;
        break;
    }

    // Get the current context
    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: textColor),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      message,
                      style: TextStyle(color: textColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          duration: duration,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } else {
      // Fallback to Get.snackbar if no context
      Get.snackbar(
        title,
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: backgroundColor,
        colorText: textColor,
        duration: duration,
        icon: Icon(icon, color: textColor),
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      );
    }
  }

  static void showSuccess(String title, String message, {
    Duration duration = const Duration(seconds: 5),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.success,
      duration: duration,
    );
  }

  static void showError(String title, String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.error,
      duration: duration,
    );
  }

  static void showWarning(String title, String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.warning,
      duration: duration,
    );
  }

  static void showInfo(String title, String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      title: title,
      message: message,
      type: SnackbarType.info,
      duration: duration,
    );
  }
}
