import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_model.dart';
import '../services/dm_contact_service.dart';

part 'gen/dm_contact_provider.g.dart';

@riverpod
DMContactService dmContactService(Ref ref) {
  return DMContactService();
}

@riverpod
Future<List<UserModel>> dmContactSearch(Ref ref, String query) {
  final service = ref.watch(dmContactServiceProvider);
  return service.searchContacts(query);
}
