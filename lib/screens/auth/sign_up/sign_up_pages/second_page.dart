import 'package:flutter/material.dart';
import 'package:pickture/screens/auth/widgets/auth_text_field.dart';

class SecondPage extends StatelessWidget {
  final TextEditingController controller;
  final String? errorMessage;
  final bool obscureText;
  final Function onSuffixIconPressed;

  const SecondPage({required this.controller, required this.obscureText, required this.onSuffixIconPressed, this.errorMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "비밀번호 만들기",
          style: TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 12),
        const Text(
          "다른 사람이 추측할 수 없는 6자 이상의 문자 및 숫자, 특수문자 중 2가지 이상을 포함하는 비밀번호를 만드세요.",
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 15),
        AuthTextField(
          controller: controller,
          hintText: '비밀번호',
          errorMessage: errorMessage,
          obscureText: obscureText,
          onSuffixIconPressed: () => onSuffixIconPressed(),
        ),
      ],
    );
  }
}
