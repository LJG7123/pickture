import 'dart:async';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/providers/notification_provider.dart';
import 'package:pickture/providers/router_provider.dart';
import 'core/bootstrap/bootstrap.dart';
import 'core/bootstrap/error_handlers.dart';
import 'core/error/error_widget.dart';
import 'core/design_system/theme.dart';

final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void main() {
  runZonedGuarded(() async {
    final container = await bootstrap();

    runApp(
      UncontrolledProviderScope(
        container: container,
        child: MyApp(),
      ),
    );
  }, handleZoneError);
}

class MyApp extends ConsumerWidget {
  MyApp({super.key}) {
    _requestNotificationPermission();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(authStateProvider);
    var router = ref.watch(routerProvider);
    var notification = ref.read(notificationProvider.notifier);

    if (authState.value != null && ref.read(authProvider).value == null) {
      Future(() => ref.read(authProvider.notifier).fetchUserData());
    }

    ref.listen(currentRouteProvider, (previous, next) {
      if (next.path == '/home') {
        notification.listenForegroundMessage();
      } else {
        notification.cancelForegroundMessage();
      }
    });

    return MaterialApp.router(
      routerConfig: router,
      scaffoldMessengerKey: scaffoldMessengerKey,
      builder: (context, child) {
        return GlobalErrorWidget(
          child: child ?? const SizedBox(),
        );
      },
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.light,
    );
  }

  void _requestNotificationPermission() {
    FirebaseMessaging.instance.requestPermission().then((value) {
      if (value.authorizationStatus == AuthorizationStatus.denied) {
        scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
          content: const Text("알림 기능을 사용하려면 알림 권한을 허용해야 합니다."),
          duration: const Duration(seconds: 10),
          action: SnackBarAction(label: "이동", onPressed: () => AppSettings.openAppSettings(type: AppSettingsType.notification)),
        ));
      }
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
      );
    });
  }
}
