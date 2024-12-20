import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/routes.dart';
import 'core/bootstrap/bootstrap.dart';
import 'core/bootstrap/error_handlers.dart';
import 'core/error/error_widget.dart';

void main() {
  runZonedGuarded(() async {
    final container = await bootstrap();
    
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
  }, handleZoneError);
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: router,
      builder: (context, child) {
        return GlobalErrorWidget(
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
