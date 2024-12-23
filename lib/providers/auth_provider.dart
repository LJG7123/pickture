import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pickture/models/user_model.dart';
import 'package:pickture/services/auth_service.dart';
import 'package:pickture/utils/validator.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) =>
        AuthNotifier(AuthService(FirebaseAuth.instance,
            FirebaseFirestore.instance, GoogleSignIn())));

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(const AsyncValue.data(null));

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authService.signIn(email, password));
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => authService.signInWithGoogle());
  }

  Future<void> signUpWithGoogle(String dob, String name) async {
    state = const AsyncValue.loading();
    state =
        await AsyncValue.guard(() => authService.signUpWithGoogle(dob, name));
  }

  Future<bool> isEmailAvailable(String email) async {
    if (!Validator.isEmailValid(email)) return false;
    return authService.isEmailAvailable(email);
  }

  bool isPasswordAvailable(String password) {
    return Validator.isPasswordValid(password);
  }
}
