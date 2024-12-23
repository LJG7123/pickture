import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField(
      {super.key,
      required this.controller,
      required this.hintText,
      this.onSuffixIconPressed,
      this.obscureText,
      this.errorMessage});

  final TextEditingController controller;
  final String hintText;
  final VoidCallback? onSuffixIconPressed;
  final bool? obscureText;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
          errorText: errorMessage,
          suffixIcon: onSuffixIconPressed == null
              ? null
              : IconButton(
                  onPressed: onSuffixIconPressed,
                  icon: Icon(
                      obscureText! ? Icons.visibility_off : Icons.visibility))),
    );
  }
}
