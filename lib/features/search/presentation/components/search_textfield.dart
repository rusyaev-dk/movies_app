import 'package:flutter/material.dart';

class SearchTextField extends StatelessWidget {
  const SearchTextField({
    super.key,
    this.prefixIcon,
    this.suffixIcon,
    required this.hintText,
    required this.onChanged,
  });

  final void Function(String) onChanged;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onChanged,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
        fillColor: Theme.of(context).colorScheme.surface,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(
          prefixIcon,
          color: Theme.of(context).colorScheme.secondary,
        ),
        hintText: hintText,
      ),
    );
  }
}
