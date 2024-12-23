import '../models/user_model.dart';
import '../repositories/user_repository.dart';
import '../core/error/app_exception.dart';

class UserService {
  final UserRepository _repository;

  // 메모리 캐시
  final Map<String, UserModel> _userCache = {};

  UserService({UserRepository? repository})
      : _repository = repository ?? UserRepository();

  Future<UserModel?> getUser(String userId) async {
    try {
      // 캐시 확인
      if (_userCache.containsKey(userId)) {
        return _userCache[userId];
      }

      final user = await _repository.getUser(userId);
      if (user != null) {
        _userCache[userId] = user;
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

    return _repository.searchUsers(query);
  }

  Future<List<UserModel>> getAllUsers() async {
    try {
      return await _repository.getAllUsers();
    } catch (e) {
      throw AppException(
        '사용자 목록을 불러올 수 없습니다.',
        code: 'get_users_failed',
        details: e.toString(),
      );
    }
  }
}
