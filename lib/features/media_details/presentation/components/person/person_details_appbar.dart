import 'package:flutter/material.dart';

class PersonDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PersonDetailsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.share))],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 75);
}
