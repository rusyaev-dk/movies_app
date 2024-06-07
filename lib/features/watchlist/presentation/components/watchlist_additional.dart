import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:movies_app/core/themes/theme.dart';

class NoAddedWatchlistMedia extends StatelessWidget {
  const NoAddedWatchlistMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Animate(
            effects: const [ShakeEffect()],
            child: Icon(
              Icons.bookmark_border,
              size: 160,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "You haven't added anything to your watch list yet",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .headingTextStyle
                .copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ],
      ),
    );
  }
}
