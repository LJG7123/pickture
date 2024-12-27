import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpandedElevatedIconButton extends StatelessWidget {
  const ExpandedElevatedIconButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.iconAsset,
  });

  final VoidCallback onPressed;
  final String text;
  final SvgPicture? iconAsset;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isDark ? Colors.white : Colors.black,
          side: BorderSide(
            color: isDark ? Colors.white : Colors.grey.shade300,
            width: isDark ? 2 : 1,
          ),
          backgroundColor: Colors.transparent,
        ),
        icon: iconAsset ?? const SizedBox(),
        label: Text(text),
      ),
    );
  }
}
