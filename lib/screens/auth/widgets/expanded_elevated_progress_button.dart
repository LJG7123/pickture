import 'package:flutter/material.dart';

class ExpandedElevatedProgressButton extends StatelessWidget {
  const ExpandedElevatedProgressButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.isLoading,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? Colors.white : Colors.black,
          side: BorderSide(
            color: isDark ? Colors.white : Colors.grey.shade300,
            width: isDark ? 2 : 1,
          ),
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
          disabledForegroundColor: isDark ? Colors.white54 : Colors.black38,
        ),
        child: isLoading
            ? SizedBox(
                width: 30,
                height: 30,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: isDark ? Colors.white : Colors.black,
                ),
              )
            : Text(text),
      ),
    );
  }
}
