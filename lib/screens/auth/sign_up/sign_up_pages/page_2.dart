import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/screens/auth/widgets/auth_text_field.dart';

class Page2 extends ConsumerWidget {
  final TextEditingController controller;
  final String? errorMessage;
  final StateProvider<bool> obscurePasswordProvider;

  const Page2({required this.controller, this.errorMessage, required this.obscurePasswordProvider, super.key});

  void _togglePasswordVisibility(WidgetRef ref) {
    ref.read(obscurePasswordProvider.notifier).state =
        !ref.read(obscurePasswordProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obscurePassword = ref.watch(obscurePasswordProvider);

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
          obscureText: obscurePassword,
          onSuffixIconPressed: () => _togglePasswordVisibility(ref),
        ),
      ],
    );
  }
}
