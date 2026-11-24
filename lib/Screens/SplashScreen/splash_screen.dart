
import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Screens/Authentication/Sign%20In/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:Padres360/Screens/SplashScreen/on_board.dart';
import 'package:Padres360/constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../currency.dart';
import '../Home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  void getPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();
  }

  int retryCount = 0;

  checkUserValidity() async {
    final bool isConnected = await InternetConnection().hasInternetAccess;
    if (isConnected) {
      nextPage();
    } else {
      if (retryCount < 3) {
        retryCount++;
        checkUserValidity();
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Sin conexión a Internet"),
            content: const Text(
              "Por favor, verifica tu conexión a Internet e inténtalo de nuevo.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  checkUserValidity();
                },
                child: const Text("Aceptar"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getPermission();
    CurrencyMethods().getCurrencyFromLocalDatabase();
    checkUserValidity();
    setLanguage();
  }

  Future<void> setLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguageCode = prefs.getString('lang') ?? 'es';
    setState(() {
      selectedLanguage = savedLanguageCode;
    });
  }

  Future<void> nextPage() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.white,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      );
    });
    final viewOnBoard = await UserService.getViewOnBoard();
    if (viewOnBoard) {
      final refreshToken = await UserService.getRefreshToken();
      if (refreshToken != '') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnBoard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: kMainColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: kMainColor,
        body: Center(
          child: Container(
              height: 230,
              width: 230,
              decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage(splashLogo)),
              ),
            ),
          ),
        ),
    );
  }
}
