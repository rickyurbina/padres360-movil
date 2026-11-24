import 'package:Padres360/Core/theme/app_colors.dart';
import 'package:flutter/material.dart';

const kMainColor = AppColors.kPrimary;
const kSecondaryColor = AppColors.kSecondary;
const kAccentColor = Color(0xfff2f4f7);

// Texto y fondo
const kWhite = Color(0xFFFFFFFF);
const kDarkWhite = Color(0xFFF1F7F7);
const kBackgroundColor = AppColors.kSurfaceLight;
const kTitleColor = AppColors.kNeutralColor;
const kGreyTextColor = Color(0xFF828282);

// Bordes y neutros
const kBorderColor = AppColors.kBorder;
const kBorderColorTextField = Color(0xFFC2C2C2);
const kBorder = AppColors.kBorder;
const updateBorderColor = Color(0xFFD8D8D8);
const kNeutralColor = AppColors.kNeutral700;

// Estados
const kSuccessColor = AppColors.kSuccess;
const kErrorColor= AppColors.kError;

// Plan premium (puedes conservar estos o personalizarlos con los colores principales)
const kPremiumPlanColor = Color(0xFFf59e08);
const kPremiumPlanColor2 = AppColors.kNeutralColor;

bool isPrintEnable = false;
// const String appVersion = '4.9';
String noProductImageUrl = 'images/no_product_image.png';

///_______Purchase_Code________________________________________
String purchaseCode = 'Enter your purchase code';

///---------update information---------------

const String splashLogo = 'images/splashLogo.png';
const String onboard1 = 'images/onboard1.png';
const String onboard2 = 'images/onboard2.png';
const String onboard3 = 'images/onboard3.png';
const String logo = 'images/logo.png';
const String appsName = 'Padres 360';
const String companyWebsite = 'https://padres360.mx/';
const String companyName = 'U3 Digital';

bool connected = false;

const kButtonDecoration = BoxDecoration(
  borderRadius: BorderRadius.all(
    Radius.circular(5),
  ),
);

const kInputDecoration = InputDecoration(
  hintStyle: TextStyle(color: kGreyTextColor),
  floatingLabelBehavior: FloatingLabelBehavior.always,
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(40.0)),
    borderSide: BorderSide(color: kBorderColor, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(40.0)),
    borderSide: BorderSide(color: kMainColor, width: 1),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(40.0)),
    borderSide: BorderSide(color: kErrorColor, width: 1),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(40.0)),
    borderSide: BorderSide(color: kErrorColor, width: 1),
  ),
  errorStyle: TextStyle(
    color: kErrorColor,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
  ),
);

// final gTextStyle = GoogleFonts.poppins(
//   color: Colors.white,
// );

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(1.0),
    borderSide: const BorderSide(color: kBorderColorTextField),
  );
}

final otpInputDecoration = InputDecoration(
  contentPadding: const EdgeInsets.symmetric(vertical: 5.0),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

///__________Language________________________________
Map<String, String> languageMap = {
  'English': 'en',
  'Spanish': 'es',
};

String formatPointNumber(num value) {
  if (value % 1 == 0) {
    return value.toInt().toString();
  } else {
    return value.toStringAsFixed(2);
  }
}

String? selectedLanguage = languageMap['Spanish'];

//withValues extension on color with a required value alpha
extension ColorExt on Color {
  Color withValues({required double alpha}) {
    return Color.fromARGB((alpha * 255).toInt(), red, green, blue);
  }
}

