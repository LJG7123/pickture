import 'package:flutter/material.dart';

class ExpandedElevatedProgressButton extends StatelessWidget {
  const ExpandedElevatedProgressButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.isLoading});

  final VoidCallback onPressed;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(strokeWidth: 3),
              )
            : Text(text),
      ),
    );
  }
}
