import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpandedElevatedButton extends StatelessWidget {
  const ExpandedElevatedButton(
      {super.key, required this.onPressed, required this.text, this.iconAsset});

  final VoidCallback onPressed;
  final String text;
  final String? iconAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: iconAsset == null ? null : SvgPicture.asset(iconAsset!),
        label: Text(text),
      ),
    );
  }
}
