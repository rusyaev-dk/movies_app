import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/routing/app_routes.dart';

class RouterErrorScreen extends StatelessWidget {
  const RouterErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Text("Oops, something went wrong :("),
          TextButton(
              onPressed: () {
                context.go(AppRoutes.home);
              },
              child: const Text("Home")),
        ],
      ),
    );
  }
}
