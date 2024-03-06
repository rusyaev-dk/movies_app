import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.obscureText = false,
    required this.hintText,
    required this.prefixIcon,
  });

  final TextEditingController controller;
  final bool obscureText;
  final IconData prefixIcon;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: '*',
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(16),
        ),
        prefixIcon: Icon(prefixIcon),
        hintText: hintText,
      ),
    );
  }
}
