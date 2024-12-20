import '../models/user_model.dart';
import '../repositories/dm_contact_repository.dart';

class DMContactService {
  final DMContactRepository _repository;

  DMContactService({DMContactRepository? repository})
      : _repository = repository ?? DMContactRepository();

  Future<List<UserModel>> searchContacts(String query) async {
    if (query.isEmpty) {
      return [];
    }
    return _repository.searchContacts(query);
  }
}
