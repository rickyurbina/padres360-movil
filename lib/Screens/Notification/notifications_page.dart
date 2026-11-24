import 'dart:async';

import 'package:Padres360/Const/states.dart';
import 'package:Padres360/Repository/constant_functions.dart';
import 'package:Padres360/Screens/Authentication/Sign%20In/Model/LogInResponseModel.dart';
import 'package:Padres360/Screens/Authentication/Sign%20In/Model/user_role_enum.dart';
import 'package:Padres360/Screens/Notification/Model/notification_incidence.dart';
import 'package:Padres360/Screens/Notification/Repo/notification_repo.dart';
import 'package:Padres360/Screens/States/EmptyView.dart';
import 'package:Padres360/Screens/States/ErrorView.dart';
import 'package:Padres360/Screens/States/LoadingView.dart';
import 'package:Padres360/extensions/datetime/time_ago.dart';
import 'package:Padres360/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:Padres360/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notification_detail_page.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  final Student? student;

  const NotificationsScreen({super.key, this.student});

  @override
  ConsumerState<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  ViewState state = ViewState.loading;
  List<NotificationIncidence> notifications = [];
  final notificationRepository = NotificationRepository();
  StreamSubscription? _notifSubscription;

  @override
  void initState() {
    super.initState();
    _loadNotifications(context: context);

    _notifSubscription = NotificationService.onForegroundNotification.listen((
      msg,
    ) {
      debugPrint("🔔 Nueva notificación en primer plano, recargando...");
      _loadNotifications(context: context);
    });
  }

  @override
  void dispose() {
    _notifSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadNotifications({required BuildContext context}) async {
    try {
      final loadedNotifications = await notificationRepository.loadNotificaton(
        context: context,
      );
      final user = await UserService.getUser();

      List<NotificationIncidence> finalList = loadedNotifications;

      if (user.role == UserRole.PARENT && widget.student?.id != null) {
        finalList = loadedNotifications.where((notification) {
          return notification.studentId == widget.student?.id;
        }).toList();
      } else if (user.role == UserRole.TEACHER) {
        finalList = loadedNotifications;
      } else if (user.role == UserRole.PARENT && widget.student?.id == null) {
        finalList = loadedNotifications;
      }

      setState(() {
        notifications = finalList;

        if (notifications.isEmpty) {
          state = ViewState.empty;
        } else {
          state = ViewState.loaded;
        }
      });
    } catch (e) {
      print('Error loading notifications: $e');
      setState(() => state = ViewState.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.student != null
            ? Text('Incidencias de ${widget.student!.firstName}')
            : const Text('Notificaciones'),
      ),
      body: switch (state) {
        ViewState.loading => const LoadingView(),
        ViewState.empty => const EmptyView(),
        ViewState.error => ErrorView(
          onRetry: () {
            _loadNotifications(context: context);
          },
        ),
        ViewState.loaded => ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: notifications.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final item = notifications[index];
            return notificationItem(context, incidence: item);
          },
        ),
      },
    );
  }

  Widget notificationItem(
    BuildContext context, {
    required NotificationIncidence incidence,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final bool? wasRead = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NotificationDetailScreen(idIncidence: incidence.id),
          ),
        );

        // Si regresó `true`, entonces se leyó
        if (wasRead == true) {
          setState(() {
            incidence.read = true;
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(color: kWhite),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 24,
                  child: Icon(
                    Icons.notifications,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                if (!(incidence.read ?? false))
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: kErrorColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: kWhite, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    incidence.incidenceToShow ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: kNeutralColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    incidence.createdAt.timeAgo,
                    style: const TextStyle(fontSize: 13, color: kGreyTextColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
