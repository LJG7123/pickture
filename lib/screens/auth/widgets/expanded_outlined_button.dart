import 'package:flutter/material.dart';

class ExpandedOutlinedButton extends StatelessWidget {
  const ExpandedOutlinedButton(
      {super.key, required this.onPressed, required this.text});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(onPressed: onPressed, child: Text(text)),
    );
  }
}
