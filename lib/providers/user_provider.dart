import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/models/user_model.dart';
import 'package:pickture/services/user_service.dart';

final userProvider = StateNotifierProvider<UserNotifier, List<UserModel>>(
    (ref) => UserNotifier(UserService(FirebaseFirestore.instance)));

class UserNotifier extends StateNotifier<List<UserModel>> {
  final UserService userService;

  UserNotifier(this.userService) : super([]);

  Future<void> getUserModel(List<String> userIds) async {
    final userModels = await userService.getUserModels(userIds);
    state = userModels;
  }
}
