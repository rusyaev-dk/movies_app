import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
  });

  final TextEditingController? controller;
  final bool obscureText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(prefixIcon),
        hintText: hintText,
      ),
    );
  }
}
