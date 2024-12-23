import 'package:flutter/material.dart';
import 'package:pickture/screens/auth/widgets/auth_text_field.dart';

class Page1 extends StatelessWidget {
  final TextEditingController controller;
  final String? errorMessage;

  const Page1({required this.controller, this.errorMessage, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "이메일 주소 입력",
          style: TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 12),
        const Text(
          "회원님에게 연락할 수 있는 이메일 주소를 입력해 주세요.",
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 36),
        AuthTextField(
          controller: controller,
          hintText: 'Email',
          errorMessage: errorMessage,
        ),
      ],
    );
  }
}
