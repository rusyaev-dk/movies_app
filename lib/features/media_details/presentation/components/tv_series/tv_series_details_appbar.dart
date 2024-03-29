import 'package:flutter/material.dart';

class TVSeriesDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TVSeriesDetailsAppBar({
    super.key,
    required this.tvSeriesId,
  });

  final int tvSeriesId;

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
