import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/firebase_options.dart';
import 'package:pickture/routes.dart';
import 'core/error/error_provider.dart';
import 'core/error/error_widget.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Flutter 에러 핸들링
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
    };

    // 플랫폼 에러 핸들링
    PlatformDispatcher.instance.onError = (error, stack) {
      FlutterError.presentError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
        ),
      );
      return true;
    };

    runApp(
      ProviderScope(
        observers: [AppErrorListener()],
        child: const MyApp(),
      ),
    );
  }, (error, stack) {
    // Zone 에러 핸들링
    debugPrint('Zone 에러: $error\n$stack');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalErrorWidget(
      child: MaterialApp.router(
        routerConfig: router,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
      ),
    );
  }
}
