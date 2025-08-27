import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

void showErrorSnackBar(BuildContext context, String message) {
  // Hide any existing snackbars to avoid overlap
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  // Show the new custom snackbar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          const Icon(LucideIcons.alertTriangle, color: Colors.white),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red.shade700,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      duration: const Duration(seconds: 4), // A slightly longer duration
    ),
  );
}
