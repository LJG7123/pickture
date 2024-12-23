import '../models/user_model.dart';
import '../repositories/dm_contact_repository.dart';
import '../core/error/app_exception.dart';

class DMContactService {
  final DMContactRepository _repository;

  DMContactService({DMContactRepository? repository})
      : _repository = repository ?? DMContactRepository();

  Future<List<UserModel>> searchContacts(
      String query, String currentUserId) async {
    if (query.trim().isEmpty) {
      throw AppException(
        '검색어를 입력해주세요',
        code: 'empty_query',
      );
    }
    try {
      final contacts = await _repository.searchContacts(query, currentUserId);
      if (contacts.isEmpty) {
        throw AppException(
          '검색 결과가 없습니다',
          code: 'no_results',
        );
      }
      return contacts;
    } catch (e) {
      if (e is AppException) rethrow;
      throw AppException(
        '사용자 검색에 실패했습니다',
        code: 'search_failed',
        details: e.toString(),
      );
    }
  }
}
