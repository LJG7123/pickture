import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'app_exception.dart';

part 'error_provider.g.dart';

@Riverpod(keepAlive: true)
class ErrorNotifier extends _$ErrorNotifier {
  @override
  AppException? build() => null;

  void setError(AppException error) {
    state = error;
  }

  void clearError() {
    state = null;
  }
}

// 전역 에러 리스너
class AppErrorListener extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (newValue is AsyncError) {
      final error = newValue.error;
      if (error is AppException) {
        container.read(errorNotifierProvider.notifier).setError(error);
      } else {
        container.read(errorNotifierProvider.notifier).setError(
              AppException('알 수 없는 오류가 발생했습니다.',
                  details: error.toString()),
            );
      }
    }
  }
} 