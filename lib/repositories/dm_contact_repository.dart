import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class DMContactRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<UserModel>> searchContacts(
      String query, String currentUserId) async {
    final snapshot = await _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '${query}z')
        .where(FieldPath.documentId, isNotEqualTo: currentUserId)
        .limit(10)
        .get();

    return snapshot.docs
        .map((doc) => UserModel.fromJson(doc.id, doc.data()))
        .toList();
  }
}
