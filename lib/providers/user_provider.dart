import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

part 'gen/user_provider.g.dart';

@riverpod
UserService userService(Ref ref) {
  return UserService();
}

@riverpod
Future<UserModel?> user(Ref ref, String userId) async {
  if (userId.isEmpty) return null;
  return ref.read(userServiceProvider).getUser(userId);
}

@riverpod
Stream<List<UserModel>> userSearch(Ref ref, String query) {
  if (query.isEmpty) return Stream.value([]);
  return ref.read(userServiceProvider).searchUsers(query);
}

@riverpod
Future<List<UserModel>> allUsers(Ref ref) async {
  return ref.read(userServiceProvider).getAllUsers();
}

@riverpod
class SelectedUsers extends _$SelectedUsers {
  @override
  Set<UserModel> build() {
    return {};
  }

  void toggleUser(UserModel user) {
    if (state.contains(user)) {
      state = {...state}..remove(user);
    } else {
      state = {...state, user};
    }
  }

  void clearSelection() {
    state = {};
  }

  bool isSelected(UserModel user) {
    return state.contains(user);
  }
}
