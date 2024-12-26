import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/providers/post_provider.dart';
import 'package:pickture/screens/post/widgets/post_card/post_card.dart';
import 'package:pickture/screens/post/widgets/post_card/widgets/save_dialog.dart';

class PostScreen extends ConsumerStatefulWidget {
  const PostScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PostScreenState();
}

class _PostScreenState extends ConsumerState {
  late final StreamSubscription foregroundMessageSubscription;

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
    const channel = AndroidNotificationChannel('high_importance_channel', 'High Importance Notifications', importance: Importance.max);

    var iOSInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
    );
    var androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.getActiveNotifications();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (detail) {
      if (detail.payload == null) return;
      context.push('/chats');
      context.push('/chats/${detail.payload}');
    });

    foregroundMessageSubscription = FirebaseMessaging.onMessage.listen((message) {
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

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
      context.push('/chats');
      context.push('/chats/${message.data['chatRoomId']}');
    }
  }

  @override
  void initState() {
    super.initState();
    setupInteractedMessage();
    setupForegroundMessage();
  }

  @override
  void dispose() {
    foregroundMessageSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(postProvider);

    return Scaffold(
      appBar: _buildAppBar(context),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          final post = posts[index];
          return PostCard(post: post);
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Post"),
      centerTitle: true,
      actions: [
        Row(
          children: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const SaveDialog(),
                );
              },
              icon: const Icon(Icons.add),
            ),
            IconButton(
              //TODO 채팅창 이동동
              onPressed: () {},
              icon: const Icon(Icons.send),
            ),
          ],
        )
      ],
    );
  }
}
