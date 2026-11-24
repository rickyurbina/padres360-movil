import 'package:flutter/material.dart';


class AppColors {
  // Colores principales
  static const kPrimary = Color(0xff0a92cd);
  static const kOnPrimary = Color(0xffF1F1F1);

  static const kSecondary = Color(0xfffbbd48);
  static const kOnSecondary = Color(0xffffffff);

  static const kTertiary = Color(0xff00adc4);
  static const kOnTertiary = Color(0xffffffff);

// Colores de superficie
  static const kSurfaceLight = Color(0xfff2f4f7);
  static const kOnSurfaceLight = Color(0xff1F1F1F);

  static const kPrimaryContainerLight = Color(0xffffffff);
  static const kOnPrimaryContainerLight = Color(0xff1F1F1F);

// Neutrales y bordes
  static const kBorder = Color(0xff7E7E7E);
  static const kNeutral700 = Color(0xff4D4D4D);
  static const kNeutralColor = Color(0xFF333333);
  static const kDividerColor = Color(0xffD7D9DE);

// Estados
  static const kWarning = Color(0xffFF900C);
  static const kInfo = Color(0xff2400FF);
  static const kSuccess = Color(0xff00B243);
  static const kError = Color(0xffF23B3D);

  static const MaterialColor kEmergency = MaterialColor(
    0xFFD32F2F, // base (500)
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFD32F2F),
      600: Color(0xFFC62828),
      700: Color(0xFFB71C1C),
      800: Color(0xFF8E0000),
      900: Color(0xFF6A0000),
    },
  );
}

final List<Color> chartColors = [
  AppColors.kPrimary,
  Colors.blue.shade600,
  Colors.green.shade600,
  Colors.orange.shade600,
  Colors.purple.shade600,
  Colors.teal.shade600,
];