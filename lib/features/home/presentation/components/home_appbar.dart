import 'package:flutter/material.dart';
import 'package:movies_app/uikit/text/text.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

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
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Image.asset("assets/images/app_logo.png"),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            "The Movie Database",
            textAlign: TextAlign.center,
            style: AppTextScheme.of(context).headline,
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
