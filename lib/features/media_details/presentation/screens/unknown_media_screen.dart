import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/uikit/buttons/custom_buttons.dart';
import 'package:movies_app/uikit/colors/app_color_sheme.dart';
import 'package:movies_app/uikit/text/app_text_sheme.dart';

class UnknownMediaScreen extends StatelessWidget {
  const UnknownMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.broken_image,
              size: 160,
              color: Theme.of(context).colorScheme.surface,
            ),
            const SizedBox(height: 20),
            Text(
              "Oops, it seems we cannot find info about this media :(",
              textAlign: TextAlign.center,
              style: AppTextScheme.of(context).headline.copyWith(
                    fontSize: 18,
                    color: AppColorScheme.of(context).onBackground,
                  ),
            ),
            const SizedBox(height: 20),
            CustomGradientButton(
              text: "Go back",
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
