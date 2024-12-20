import 'package:flutter/material.dart';

class Page2 extends StatelessWidget {
  final TextEditingController controller;

  const Page2({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "이름 입력",
          style: TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 12),
        const Text(
          "회원님의 이름을 입력해 주세요.",
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 36),
        TextField(
          controller: controller,
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
      ],
    );
  }
}
