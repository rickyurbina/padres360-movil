import 'package:Padres360/Screens/DashBoard/dashboard_selector.dart';
import 'package:Padres360/Screens/Notification/notifications_page.dart';
import 'package:Padres360/core/theme/app_colors.dart';
import 'package:Padres360/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Padres360/Screens/Settings/settings_screen.dart';
import 'package:Padres360/constants.dart';
import 'package:new_version_plus/new_version_plus.dart';
import 'package:badges/badges.dart' as badges; // Añade este import

import '../../providers/badge_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  bool isNoInternet = false;
  int _tabIndex = 0;
  bool _dialogShown = false;

  int get tabIndex => _tabIndex;

  set tabIndex(int v) {
    _tabIndex = v;
    setState(() {});
  }

  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _tabIndex);

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkForUpdate();
      await _syncBadgeOnAppStart();
    });
  }

  Future<void> _syncBadgeOnAppStart() async {
    try {
      if (!mounted) return;

      final ref = ProviderScope.containerOf(context);
      await ref.read(badgeProvider.notifier).syncWithSystemBadge();
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.syncUnreadNotifications();

      debugPrint("✅ Badge sincronizado al iniciar app");
    } catch (e) {
      debugPrint("❌ Error sincronizando badge al iniciar: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      // App volvió a primer plano
      _syncBadgeOnAppResume();
    }
  }

  Future<void> _syncBadgeOnAppResume() async {
    try {
      if (!mounted) return;

      final ref = ProviderScope.containerOf(context);
      await ref.read(badgeProvider.notifier).syncWithSystemBadge();
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.syncUnreadNotifications();

      debugPrint("✅ Badge sincronizado al volver a primer plano");
    } catch (e) {
      debugPrint("❌ Error sincronizando badge al volver: $e");
    }
  }

  Future<void> _checkForUpdate() async {
    final newVersion = NewVersionPlus(
      androidId: "com.u3digital.padres360",
      iOSId: "6751250209",
    );

    final status = await newVersion.getVersionStatus();
    debugPrint("Local: ${status?.localVersion}");
    debugPrint("Store: ${status?.storeVersion}");
    debugPrint("CanUpdate: ${status?.canUpdate}");

    if (!_dialogShown && status != null && status.canUpdate) {
      _dialogShown = true;

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: const Text("Actualización requerida"),
          content: Text(
            "Debes actualizar la aplicación a la versión ${status.storeVersion} para continuar.",
          ),
          actions: [
            TextButton(
              onPressed: () => newVersion.launchAppStore(status.appStoreLink),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.kPrimary,
              ),
              child: const Text("Actualizar ahora"),
            ),
          ],
        ),
      );
    }
  }

  // Método para construir el icono con badge
  Widget _buildNotificationIcon(bool isSelected, int badgeCount) {
    final iconWidget = Container(
      width: 60,
      height: 28,
      decoration: isSelected
          ? BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        color: kMainColor.withAlpha(50),
      )
          : null,
      child: Icon(
        Icons.notifications,
        color: isSelected ? AppColors.kPrimary : kGreyTextColor,
        size: 28,
      ),
    );

    if (badgeCount > 0) {
      return badges.Badge(
        badgeContent: Text(
          badgeCount.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
        badgeStyle: const badges.BadgeStyle(
          badgeColor: Colors.red,
          padding: EdgeInsets.all(4),
        ),

        /// 🔥 Badge más pegado al icono
        position: badges.BadgePosition.topEnd(
          top: 0,
          end: 0,
        ),

        child: iconWidget,
      );
    }

    return iconWidget;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("¿Estás seguro?"),
            content: Text("¿Deseas salir de la aplicación?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(true);
                },
                child: Text("Si"),
              ),
            ],
          ),
        );
        return shouldPop ?? false;
      },
      child: Consumer(
        builder: (context, ref, __) {
          // Observamos el badgeProvider
          final badgeCount = ref.watch(badgeProvider);

          return Scaffold(
              body: PageView(
                controller: pageController,
                onPageChanged: (v) {
                  tabIndex = v;
                },
                children: const [
                  DashboardSelector(),
                  NotificationsScreen(),
                  SettingScreen(),
                ],
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: _tabIndex,
                backgroundColor: Colors.white,
                onTap: (index) {

                  setState(() {
                    _tabIndex = index;
                    pageController.jumpToPage(index);
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: _tabIndex == 0
                        ? Container(
                      width: 60,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: kMainColor.withAlpha(50),
                      ),
                      child: const Icon(
                        Icons.home_filled,
                        color: AppColors.kPrimary,
                        size: 28,
                      ),
                    )
                        : Container(
                      width: 60,
                      height: 28,
                      child: const Icon(
                        Icons.home_filled,
                        color: kGreyTextColor,
                        size: 28,
                      ),
                    ),
                    label: "Inicio",
                  ),
                  BottomNavigationBarItem(
                    icon: _buildNotificationIcon(_tabIndex == 1, badgeCount),
                    label: "Notificación",
                  ),
                  BottomNavigationBarItem(
                    icon: _tabIndex == 2
                        ? Container(
                      width: 60,
                      height: 28,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(60),
                        color: kMainColor.withAlpha(50),
                      ),
                      child: const Icon(
                        Icons.menu,
                        color: AppColors.kPrimary,
                        size: 28,
                      ),
                    )
                        : Container(
                      width: 60,
                      height: 28,
                      child: const Icon(
                        Icons.menu,
                        color: kGreyTextColor,
                        size: 28,
                      ),
                    ),
                    label: "Configuración",
                  ),
                ],
                type: BottomNavigationBarType.fixed,
                selectedItemColor: kMainColor,
                unselectedItemColor: kGreyTextColor,
                selectedLabelStyle: const TextStyle(fontSize: 14),
                unselectedLabelStyle: const TextStyle(fontSize: 14),
              ),
          );
        },
      ),
    );
  }
}

