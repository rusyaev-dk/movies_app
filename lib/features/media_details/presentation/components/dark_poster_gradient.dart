import 'package:flutter/material.dart';

class DarkPosterGradient extends StatelessWidget {
  const DarkPosterGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.black.withOpacity(0.4),
            Colors.transparent,
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.4),
            Colors.black.withOpacity(0.5),
            Colors.black.withOpacity(0.6),
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
    );
  }
}
