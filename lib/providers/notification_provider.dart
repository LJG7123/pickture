import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/providers/router_provider.dart';

final notificationProvider = StateNotifierProvider<NotificationNotifier, StreamSubscription?>((ref) => NotificationNotifier(ref));

class NotificationNotifier extends StateNotifier<StreamSubscription?> {
  final channel = const AndroidNotificationChannel('high_importance_channel', 'High Importance Notifications', importance: Importance.max);
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  Ref ref;

  NotificationNotifier(this.ref) : super(null) {
    setupInteractedMessage();
    setupForegroundMessage();
    listenForegroundMessage();
  }

  Future<void> setupInteractedMessage() async {
    /// 백그라운드 알림
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  Future<void> setupForegroundMessage() async {
    /// 포그라운드 알림
    var iOSInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
    );
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.getActiveNotifications();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (detail) {
      if (detail.payload == null) return;
      ref.read(routerProvider).push('/chats');
      ref.read(routerProvider).push('/chats/${detail.payload}');
    });
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      ref.read(routerProvider).push('/chats');
      ref.read(routerProvider).push('/chats/${message.data['chatRoomId']}');
    }
  }

  void listenForegroundMessage() {
    state = FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        flutterLocalNotificationsPlugin.show(
          message.notification.hashCode,
          message.notification?.title,
          message.notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              importance: channel.importance,
            ),
          ),
          payload: message.data['chatRoomId'],
        );
      }
    });
  }

  void cancelForegroundMessage() async {
    await state?.cancel();
    state = null;
  }

  @override
  void dispose() {
    state?.cancel();
    super.dispose();
  }
}