import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExpandedElevatedIconButton extends StatelessWidget {
  const ExpandedElevatedIconButton(
      {super.key, required this.onPressed, required this.text, this.iconAsset});

  final VoidCallback onPressed;
  final String text;
  final SvgPicture? iconAsset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: iconAsset,
        label: Text(text),
      ),
    );
  }
}
