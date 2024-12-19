import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/providers/auth_provider.dart';
import 'package:pickture/widgets/auth_text_field.dart';
import 'package:pickture/widgets/expanded_elevated_button.dart';
import 'package:pickture/widgets/expanded_outlined_button.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
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
              obscureText: _obscurePassword,
              onSuffixIconPressed: _togglePasswordVisibility,
            ),
            const SizedBox(height: 20),
            ExpandedElevatedButton(
                onPressed: () {
                  ref
                      .read(authProvider.notifier)
                      .signIn(_emailController.text, _passwordController.text);
                },
                text: '로그인'),
            const SizedBox(height: 20),
            ExpandedElevatedButton(
              onPressed: () {},
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
