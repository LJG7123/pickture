import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import '../../providers/chat_provider.dart';
import '../../providers/user_provider.dart';

part 'cache_provider.g.dart';

@riverpod
class CacheCleanupScheduler extends _$CacheCleanupScheduler {
  Timer? _cleanupTimer;

  @override
  void build() {
    ref.onDispose(() {
      _cleanupTimer?.cancel();
    });

    // 5분마다 모든 서비스의 캐시 정리
    _cleanupTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _cleanAllCaches(),
    );
  }

  void _cleanAllCaches() {
    // 각 서비스의 캐시 정리
    ref.read(chatServiceProvider).cleanExpiredCache();
    ref.read(userServiceProvider).cleanExpiredCache();
  }
}
