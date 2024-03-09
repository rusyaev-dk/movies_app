import 'package:flutter/material.dart';
import 'package:movies_app/core/themes/theme.dart';

class ListTitle extends StatelessWidget {
  const ListTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    List<Widget> shimmerChildren = [
      Container(
        height: 20,
        width: 100,
        color: Colors.white,
      ),
      const Spacer(),
      Container(
        height: 20,
        width: 40,
        color: Colors.white,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Row(
        children: title.isEmpty
            ? shimmerChildren
            : [
                Text(
                  title,
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .headingTextStyle,
                ),
                const Spacer(),
                Text(
                  "All",
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .headingTextStyle
                      .copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
      ),
    );
  }
}
