import 'package:flutter/material.dart';
import 'package:pickture/core/design_system/foundation/spacing.dart';

class ExpandedOutlinedButton extends StatelessWidget {
  const ExpandedOutlinedButton({super.key, required this.onPressed, required this.text});

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(padding: const EdgeInsets.all(AppSpacing.sm)),
        child: Text(text),
      ),
    );
  }
}
