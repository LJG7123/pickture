import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pickture/core/design_system/foundation/spacing.dart';

class ExpandedOutlinedIconButton extends StatelessWidget {
  const ExpandedOutlinedIconButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.isLoading,
    this.iconAsset,
  });

  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final SvgPicture? iconAsset;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? Colors.white : Colors.black,
          padding: const EdgeInsets.all(AppSpacing.sm),
          side: BorderSide(
            color: isDark ? Colors.white : Colors.grey.shade300,
            width: isDark ? 2 : 1,
          ),
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
          disabledForegroundColor: isDark ? Colors.white54 : Colors.black38,
        ),
        icon: isLoading ? null : iconAsset,
        label: isLoading
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
