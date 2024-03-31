import 'package:flutter/material.dart';
import 'package:movies_app/core/themes/theme.dart';

class PersonDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PersonDetailsAppBar({
    super.key,
    required this.appBarTitle,
  });

  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      forceMaterialTransparency: true,
      title: Text(
        appBarTitle,
        style: Theme.of(context).extension<ThemeTextStyles>()!.headingTextStyle,
      ),
      centerTitle: true,
      actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.share))],
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 55);
}
