import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color darkBlue = Color(0xFF1976D2);
  static const Color primaryOrange = Color(0xFFFF9800);
  static const Color darkOrange = Color(0xFFFF6F00);
  
  // API URLs (replace with your actual backend URLs)
  static const String baseUrl = 'https://your-backend-url.com/api';
  static const String loginUrl = '$baseUrl/auth/login';
  static const String registerUrl = '$baseUrl/auth/register';
  static const String forgotPasswordUrl = '$baseUrl/auth/forgot-password';
  static const String resetPasswordUrl = '$baseUrl/auth/reset-password';
  static const String uploadImageUrl = '$baseUrl/upload/image';
  static const String createRequestUrl = '$baseUrl/requests/create';
  static const String getStoresUrl = '$baseUrl/stores';
  static const String createOrderUrl = '$baseUrl/orders/create';
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryBlue, darkBlue],
  );
  
  static const LinearGradient orangeGradient = LinearGradient(
    colors: [primaryOrange, darkOrange],
  );
}

class AppHelper {
  // Show snackbar
  static void showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  // Format price
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }
  
  // Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  // Show loading dialog
  static void showLoadingDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(message),
            ],
          ),
        );
      },
    );
  }
  
  // Hide loading dialog
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }
}
