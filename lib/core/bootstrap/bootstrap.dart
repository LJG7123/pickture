import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_initialization.dart';
import 'error_handlers.dart';
import '../error/error_provider.dart';

/// 앱 부트스트랩 함수
Future<ProviderContainer> bootstrap() async {
  // 앱 초기화
  await initializeApp();

  // Provider 컨테이너 생성
  final container = ProviderContainer(
    observers: [AppErrorListener()],
  );

  // 에러 핸들러 설정
  setupErrorHandlers(container);

  return container;
}
