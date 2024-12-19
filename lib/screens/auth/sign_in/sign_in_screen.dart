import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/error_handler.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/widgets/auth_text_field.dart';
import 'package:pickture/widgets/expanded_elevated_icon_button.dart';
import 'package:pickture/widgets/expanded_elevated_progress_button.dart';
import 'package:pickture/widgets/expanded_outlined_button.dart';

class SignInScreen extends ConsumerWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _obscurePasswordProvider = StateProvider<bool>((ref) => true);
  final _signInLoadingProvider = StateProvider<bool>((ref) => false);

  SignInScreen({super.key});

  void _togglePasswordVisibility(WidgetRef ref) {
    ref.read(_obscurePasswordProvider.notifier).state =
        !ref.read(_obscurePasswordProvider);
  }

  void _onLoginButtonClicked(BuildContext context, WidgetRef ref) async {
    ref.read(_signInLoadingProvider.notifier).state = true;
    try {
      await ref
          .read(authProvider.notifier)
          .signIn(_emailController.text, _passwordController.text);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 1),
          content: Text(_getErrorMessage(e)),
        ));
      }
    }
    ref.read(_signInLoadingProvider.notifier).state = false;
  }

  String _getErrorMessage(Object error) {
    if (error is FirebaseAuthException) {
      return FirebaseErrorHandler.handleAuthError(error);
    } else {
      return '알 수 없는 오류가 발생했습니다.';
    }
  }

  void _onLoginWithGoogleButtonClicked(
      BuildContext context, WidgetRef ref) async {
    var authNotifier = ref.read(authProvider.notifier);
    await authNotifier.signInWithGoogle();

    var user = ref.read(authProvider);
    if (user == null && authNotifier.authService.userCredential != null) {
      // 유저 정보가 등록되어 있지 않은 경우
      if (context.mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("사용자 정보 미등록"),
                content: const Text("확인 버튼 클릭 시 사용자 정보 등록 화면으로 이동합니다."),
                actions: [
                  TextButton(
                    onPressed: () => context.go('/signup_with_google'),
                    child: const Text("확인"),
                  )
                ],
              );
            });
      }
    } else if (user != null) {
      // 로그인에 성공한 경우
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obscurePassword = ref.watch(_obscurePasswordProvider);
    final isLoading = ref.watch(_signInLoadingProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            AuthTextField(controller: _emailController, hintText: 'E-mail'),
            const SizedBox(height: 20),
            AuthTextField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: obscurePassword,
              onSuffixIconPressed: () => _togglePasswordVisibility(ref),
            ),
            const SizedBox(height: 20),
            ExpandedElevatedProgressButton(
              onPressed: () => _onLoginButtonClicked(context, ref),
              text: '로그인',
              isLoading: isLoading,
            ),
            const SizedBox(height: 20),
            ExpandedElevatedIconButton(
              onPressed: () => _onLoginWithGoogleButtonClicked(context, ref),
              text: 'Google 로 로그인',
              iconAsset: 'assets/images/android_light_rd_na.svg',
            ),
            const Spacer(),
            ExpandedOutlinedButton(onPressed: () {}, text: '새 계정 만들기')
          ],
        ),
      ),
    );
  }
}
