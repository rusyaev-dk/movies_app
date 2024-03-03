import 'package:flutter/material.dart';

class RouterErrorScreen extends StatelessWidget {
  const RouterErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Oops, something went wrong :("),
    );
  }
}
