import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../error/app_exception.dart';
import '../error/error_provider.dart';

/// 에러 핸들러 설정
void setupErrorHandlers(ProviderContainer container) {
  void handleAppError(String message, StackTrace? stack) {
    container.read(errorNotifierProvider.notifier).setError(
      AppException(
        message,
        details: stack?.toString(),
      ),
    );
  }

  // Flutter 에러 핸들링
  FlutterError.onError = (FlutterErrorDetails details) {
    handleAppError('앱에 문제가 발생했습니다.', details.stack);
  };

  // 플랫폼 에러 핸들링
  PlatformDispatcher.instance.onError = (error, stack) {
    handleAppError('시스템 오류가 발생했습니다.', stack);
    return true;
  };
}

/// Zone 에러 처리
void handleZoneError(Object error, StackTrace stack) {
  debugPrint('Zone 에러 발생');
  try {
    final container = ProviderContainer(observers: [AppErrorListener()]);
    container.read(errorNotifierProvider.notifier).setError(
      AppException(
        '예기치 않은 오류가 발생했습니다.',
        details: stack.toString(),
      ),
    );
  } catch (e) {
    debugPrint('Zone 에러 처리 중 추가 에러 발생: $e');
  }
} 