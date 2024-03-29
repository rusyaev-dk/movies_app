import 'package:flutter/material.dart';

class MovieDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MovieDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.airplay))],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 75);
}
