import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/presentation/components/custom_buttons.dart';
import 'package:movies_app/core/presentation/routing/app_routes.dart';
import 'package:movies_app/core/presentation/themes/theme.dart';

class RouterErrorScreen extends StatelessWidget {
  const RouterErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Oops, something went wrong...",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .headingTextStyle,
          ),
          const SizedBox(height: 20),
          CustomGradientButton(
            text: "Go home",
            onPressed: () => context.go(AppRoutes.home),
          ),
        ],
      ),
    );
  }
}
