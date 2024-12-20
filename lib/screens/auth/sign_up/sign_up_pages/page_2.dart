import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pickture/screens/auth/widgets/auth_text_field.dart';

class Page2 extends ConsumerWidget {
  final TextEditingController controller;
  final _obscurePasswordProvider = StateProvider<bool>((ref) => true);

  Page2({required this.controller, super.key});

  void _togglePasswordVisibility(WidgetRef ref) {
    ref.read(_obscurePasswordProvider.notifier).state =
        !ref.read(_obscurePasswordProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obscurePassword = ref.watch(_obscurePasswordProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "비밀번호 만들기",
          style: TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 12),
        const Text(
          "다른 사람이 추측할 수 없는 6자 이상의 문자 또는 숫자로 \n비밀번호를 만드세요.",
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 15),
        AuthTextField(
          controller: controller,
          hintText: '비밀번호',
          obscureText: obscurePassword,
          onSuffixIconPressed: () => _togglePasswordVisibility(ref),
        ),
      ],
    );
  }
}
