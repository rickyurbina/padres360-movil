import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset('assets/lottie/error.json', width: 250, height: 250),
        Text(
          "Ocurrió un error",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onRetry,
          child: Text(
            "Reintentar",
            style: const TextStyle(
              decoration: TextDecoration.underline,
              color: AppColors.kPrimary,
            ),
          ),
        ),
      ],
    )
    );
  }
}
