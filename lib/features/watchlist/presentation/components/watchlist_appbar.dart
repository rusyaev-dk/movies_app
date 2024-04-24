import 'package:flutter/material.dart';
import 'package:movies_app/core/presentation/themes/theme.dart';

class WatchlistAppBar extends StatelessWidget implements PreferredSizeWidget {
  const WatchlistAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 40, bottom: 15),
      child: Row(
        children: [
          Container(
            height: 35,
            width: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
                stops: const [0.5, 1.0],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.bookmark,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "Watchlist",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .headingTextStyle,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    return const Size(double.infinity, 75);
  }
}
