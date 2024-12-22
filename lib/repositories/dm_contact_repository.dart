import 'package:cloud_firestore/cloud_firestore.dart';
import '../core/error/app_exception.dart';
import '../models/user_model.dart';

class DMContactRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> searchContacts(
      String query, String currentUserId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: '${query}z')
          .where(FieldPath.documentId, isNotEqualTo: currentUserId)
          .limit(10)
          .get();

      return snapshot.docs.map((doc) {
        try {
          return UserModel.fromJson(doc.id, doc.data());
        } catch (e) {
          throw AppException(
            '사용자 데이터 변환 실패',
            code: 'data_parsing_error',
            details: e.toString(),
          );
        }
      }).toList();
    } catch (e) {
      if (e is AppException) rethrow;

      throw AppException(
        '연락처 검색 실패',
        code: 'search_contacts_error',
        details: e.toString(),
      );
    }
  }
}
