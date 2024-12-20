import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.onSuffixIconPressed,
      this.obscureText});

  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onSuffixIconPressed;
  final bool? obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
          suffixIcon: onSuffixIconPressed == null
              ? null
              : IconButton(
                  onPressed: onSuffixIconPressed,
                  icon: Icon(
                      obscureText! ? Icons.visibility_off : Icons.visibility))),
    );
  }
}
