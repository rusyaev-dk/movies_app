import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:movies_app/uikit/colors/app_color_sheme.dart';
import 'package:movies_app/uikit/text/app_text_sheme.dart';

class LetsFindSomethingWidget extends StatelessWidget {
  const LetsFindSomethingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Animate(
        effects: const [FadeEffect()],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.movie_creation_outlined,
              size: 160,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 10),
            Text(
              "Let's find something!",
              style: AppTextScheme.of(context)
                  .headline
                  .copyWith(color: AppColorScheme.of(context).secondary),
            ),
          ],
        ),
      ),
    );
  }
}

class NothingFoundWidget extends StatelessWidget {
  const NothingFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Animate(
            effects: const [ShakeEffect()],
            child: Icon(
              Icons.search_off,
              size: 160,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Nothing found",
            style: AppTextScheme.of(context)
                .headline
                .copyWith(color: AppColorScheme.of(context).secondary),
          )
        ],
      ),
    );
  }
}
