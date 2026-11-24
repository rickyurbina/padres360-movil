import 'dart:async';

import 'package:Padres360/Screens/Authentication/Sign%20In/sign_in_screen.dart';
import 'package:Padres360/Screens/ChildList/child_list.dart';
import 'package:Padres360/Screens/Groups/list_group_attendance.dart';
import 'package:Padres360/Screens/Home/home.dart';
import 'package:Padres360/Screens/Message/MessageToParents/select_student.dart';
import 'package:Padres360/Screens/Message/MessageToParents/send_message_to_parents.dart';
import 'package:Padres360/Screens/Notification/notification_detail_page.dart';
import 'package:Padres360/Screens/Profile%20Screen/profile_details.dart';
import 'package:Padres360/Screens/Settings/Help%20&%20Support/contact_us.dart';
import 'package:Padres360/Screens/SosScreen/EmergencyNotificationScreen.dart';
import 'package:Padres360/Screens/SplashScreen/on_board.dart';
import 'package:Padres360/Screens/SplashScreen/splash_screen.dart';
import 'package:Padres360/Screens/Subjects/subjects_screen.dart';
import 'package:Padres360/services/local_notification_service.dart';
import 'package:Padres360/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart' as pro;

import 'Screens/Authentication/forgot_password.dart';
import 'core/theme/app_theme.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // 🔥 StreamSubscriptions para limpiar al dispose
  StreamSubscription? _fcmTapSubscription;
  StreamSubscription? _localTapSubscription;

  @override
  void initState() {
    super.initState();

    // 🔥 Escuchar taps de notificaciones FCM
    _fcmTapSubscription = NotificationService.onNotificationTap.listen((payload) {
      _handleNotificationTap(payload, isLocal: false);
    });

    // 🔥 Escuchar taps de notificaciones LOCALES
    _localTapSubscription = LocalNotificationService.onLocalNotificationTap.listen((payload) {
      _handleNotificationTap(payload, isLocal: true);
    });
  }

  // 🔥 Manejar el tap de cualquier notificación
  void _handleNotificationTap(Map<String, dynamic> payload, {required bool isLocal}) {
    final id = payload["id"]?.toString();
    final route = payload["route"] ?? "notification";

    debugPrint("🔔 Tap de notificación ${isLocal ? 'LOCAL' : 'FCM'} -> route=$route id=$id");

    if (id == null || id.isEmpty) {
      debugPrint("⚠️ ID de notificación inválido");
      return;
    }

    // Navegar según la ruta
    if (route == "notification" || route == "notification_detail") {
      navigatorKey.currentState?.pushNamed(
        "/notificationDetail",
        arguments: id,
      );
    } else if (route == "emergency" || route == "emergency_detail") {
      navigatorKey.currentState?.pushNamed(
        "/emergencyDetail",
        arguments: id,
      );
    } else {
      // Ruta por defecto: ir a detalle de notificación
      navigatorKey.currentState?.pushNamed(
        "/notificationDetail",
        arguments: id,
      );
    }
  }

  @override
  void dispose() {
    // 🔥 Limpiar suscripciones al salir
    _fcmTapSubscription?.cancel();
    _localTapSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final notificationService = ref.read(notificationServiceProvider);
        notificationService.initialize();
      } catch (e) {
        debugPrint("❌ Error inicializando notification service: $e");
      }
    });

    return Builder(
        builder: (context) =>
            MaterialApp(
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Padres 360',
              initialRoute: '/',
              builder: EasyLoading.init(),
              routes: {
                '/': (context) => const SplashScreen(),
                '/login': (context) => const SignIn(),
                '/onBoard': (context) => const OnBoard(),
                '/forgotPassword': (context) => const ForgotPassword(),
                '/home': (context) => const Home(),
                '/children': (context) => const ChildrenListScreen(),
                '/subjects': (context) => const SubjectsScreen(),
                '/send-message': (context) => SendMessageScreen(),
                '/select-student': (context) => SelectStudentScreen(),
                '/edit-profile': (context) => ProfileDetails(),
                '/student-attendance': (context) => GroupsScreen(),
                '/contact-us': (context) => ContactUs(),
              },
              onGenerateRoute: (settings) {
                if (settings.name == "/notificationDetail") {
                  final data = settings.arguments as String;
                  return MaterialPageRoute(
                    builder: (_) =>
                        NotificationDetailScreen(idIncidence: data.toInt()),
                  );
                }

                if (settings.name == "/emergencyDetail") {
                  final data = settings.arguments as String;
                  return MaterialPageRoute(
                      builder: (_) =>
                          EmergencyNotificationScreen(idEmergency: data)
                  );
                }

                return null;
              },
              theme: AppTheme.kLightTheme(context),
              navigatorObservers: [NotificationNavigatorObserver()],
            )
    );
  }
}

class NotificationNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    // Ya no es necesario escuchar aquí porque ya lo hacemos en MyApp
  }
}