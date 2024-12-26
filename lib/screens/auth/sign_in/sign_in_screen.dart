import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/screens/auth/widgets/auth_text_field.dart';
import 'package:pickture/screens/auth/widgets/expanded_elevated_icon_button.dart';
import 'package:pickture/screens/auth/widgets/expanded_elevated_progress_button.dart';
import 'package:pickture/screens/auth/widgets/expanded_outlined_button.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState {
  final _googleIcon = SvgPicture.asset('assets/images/android_light_rd_na.svg');
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _obscurePasswordProvider = StateProvider<bool>((ref) => true);
  final _signInLoadingProvider = StateProvider<bool>((ref) => false);

  void _togglePasswordVisibility() {
    ref.read(_obscurePasswordProvider.notifier).state = !ref.read(_obscurePasswordProvider);
  }

  void _onLoginButtonClicked(BuildContext context) async {
    ref.read(_signInLoadingProvider.notifier).state = true;
    await ref.read(authProvider.notifier).signIn(_emailController.text, _passwordController.text);
    ref.read(_signInLoadingProvider.notifier).state = false;

    if (ref.read(authProvider).value != null) {
      // 로그인에 성공한 경우
      if (context.mounted) context.go("/home");
    }
  }

  void _onLoginWithGoogleButtonClicked(BuildContext context) async {
    var authNotifier = ref.read(authProvider.notifier);
    await authNotifier.signInWithGoogle();

    var user = ref.read(authProvider).value;
    if (user == null && authNotifier.authService.currentUser != null) {
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
                    onPressed: () {
                      context.pop();
                      context.push('/signup_with_google');
                    },
                    child: const Text("확인"),
                  )
                ],
              );
            });
      }
    } else if (user != null) {
      // 로그인에 성공한 경우
      if (context.mounted) context.go('/home');
    }
  }

  void _checkLoginState(BuildContext context) async {
    if (ref.read(authProvider.notifier).authService.currentUser != null) {
      _emailController.text = ref.read(authProvider.notifier).authService.currentUser!.email!;
      Future(() => ref.read(_signInLoadingProvider.notifier).state = true);

      await ref.read(authProvider.notifier).fetchUserData();

      if (ref.read(authProvider).value != null) {
        if (context.mounted) context.go('/home');
      }
      Future(() => ref.read(_signInLoadingProvider.notifier).state = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              onSuffixIconPressed: () => _togglePasswordVisibility(),
            ),
            const SizedBox(height: 20),
            ExpandedElevatedProgressButton(
              onPressed: () => _onLoginButtonClicked(context),
              text: '로그인',
              isLoading: isLoading,
            ),
            const SizedBox(height: 20),
            ExpandedElevatedIconButton(
              onPressed: () => _onLoginWithGoogleButtonClicked(context),
              text: 'Google 로 로그인',
              iconAsset: _googleIcon,
            ),
            const Spacer(),
            ExpandedOutlinedButton(
                onPressed: () {
                  context.push('/signup');
                },
                text: '새 계정 만들기')
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkLoginState(context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
