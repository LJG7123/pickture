import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../core/error/app_exception.dart';
import '../core/cache/cache_manager.dart';

class UserService {
  final UserRepository _repository;
  final CacheManager<UserModel> _cache;

  UserService({
    UserRepository? repository,
    Duration? cacheTTL,
  })  : _repository = repository ?? UserRepository(),
        _cache = CacheManager<UserModel>(defaultTTL: cacheTTL ?? const Duration(minutes: 30));

  Future<UserModel?> getUser(String userId) async {
    try {
      final cachedUser = _cache.get(userId);
      if (cachedUser != null) {
        return cachedUser;
      }

      final user = await _repository.getUser(userId);
      if (user != null) {
        _cache.set(userId, user);
      }
      return user;
    } catch (e) {
      throw AppException(
        '사용자 정보를 찾을 수 없습니다.',
        code: 'user_not_found',
        details: e.toString(),
      );
    }
  }

  Stream<List<UserModel>> searchUsers(String query) {
    if (query.isEmpty) {
      return Stream.value([]);
    }

    try {
      return _repository.searchUsers(query);
    } catch (e) {
      throw AppException(
        '사용자 검색에 실패했습니다.',
        code: 'search_users_failed',
        details: e.toString(),
      );
    }
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      final users = await _repository.getAllUsers();
      // 모든 사용자 정보를 캐시에 저장
      for (final user in users) {
        _cache.set(user.userId, user);
      }
      return users;
    } catch (e) {
      throw AppException(
        '사용자 목록을 불러올 수 없습니다.',
        code: 'get_users_failed',
        details: e.toString(),
      );
    }
  }

  Future<List<UserModel>> getUsersByIds(List<String> userIds) async {
    try {
      // 캐시에서 먼저 확인
      final cachedUsers = userIds.map((id) => _cache.get(id)).whereType<UserModel>().toList();

      // 캐시에 없는 사용자 ID만 필터링
      final uncachedUserIds = userIds.where((id) => _cache.get(id) == null).toList();

      if (uncachedUserIds.isEmpty) {
        return cachedUsers;
      }

      // 캐시되지 않은 사용자 정보를 한 번에 조회
      final fetchedUsers = await _repository.getUsersByIds(uncachedUserIds);

      // 새로 조회한 사용자 정보를 캐시에 저장
      for (final user in fetchedUsers) {
        _cache.set(user.userId, user);
      }

      // 캐시된 사용자와 새로 조회한 사용자를 합쳐서 반환
      return [...cachedUsers, ...fetchedUsers];
    } catch (e) {
      throw AppException(
        '사용자 정보를 찾을 수 없습니다.',
        code: 'users_not_found',
        details: e.toString(),
      );
    }
  }

  // 주기적으로 만료된 캐시 정리
  void cleanExpiredCache() {
    _cache.removeExpired();
  }

  void updateFollow(
    Map<String, List<String>> currentUserFollowing,
    Map<String, List<String>> followingUserFollow,
  ) async {
    await _repository.updateFollow(currentUserFollowing, followingUserFollow);
  }
}
