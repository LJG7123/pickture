import 'package:flutter/material.dart';

class ExpandedElevatedButton extends StatelessWidget {
  const ExpandedElevatedButton(
      {super.key, required this.onPressed, required this.text});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
