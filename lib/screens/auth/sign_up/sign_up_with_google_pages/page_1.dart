import 'package:flutter/material.dart';
import 'package:pickture/utils/date_util.dart';

class Page1 extends StatelessWidget {
  final TextEditingController controller;

  const Page1({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "생년월일 입력",
          style: TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 12),
        const Text(
          "회원님의 실제 생년월일을 입력해 주세요.",
          style: TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 36),
        TextField(
          controller: controller,
          readOnly: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          onTap: () {
            showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            ).then((value) {
              if (value == null) return;
              controller.text = value.dateOnly();
            });
          },
        ),
      ],
    );
  }
}
