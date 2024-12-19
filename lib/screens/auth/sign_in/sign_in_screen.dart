import 'package:flutter/material.dart';
import 'package:pickture/widgets/auth_text_field.dart';
import 'package:pickture/widgets/expanded_elevated_button.dart';
import 'package:pickture/widgets/expanded_outlined_button.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
            ExpandedElevatedButton(onPressed: () {}, text: '로그인'),
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
