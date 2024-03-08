import 'package:flutter/material.dart';

class ListTitle extends StatelessWidget {
  const ListTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: [
          Text(
            title,
            style: Theme.of(context)
                .textTheme
                .displayLarge!
                .copyWith(fontSize: 20),
          ),
          const Spacer(),
          Text(
            "All",
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: 20, color: Theme.of(context).colorScheme.primary),
          )
        ],
      ),
    );
  }
}
