import 'package:flutter/material.dart';
import 'package:movies_app/core/presentation/components/custom_buttons.dart';

class MediaDetailsButtons extends StatelessWidget {
  const MediaDetailsButtons({
    super.key,
    required this.favouriteBtnOnPressed,
    required this.watchListBtnOnPressed,
    required this.shareBtnOnPressed,
  });

  final void Function() favouriteBtnOnPressed;
  final void Function() watchListBtnOnPressed;
  final void Function() shareBtnOnPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIconButton(
          onPressed: favouriteBtnOnPressed,
          icon: Icons.star_border,
          text: "Favourite",
        ),
        const SizedBox(width: 10),
        CustomIconButton(
          onPressed: watchListBtnOnPressed,
          icon: Icons.bookmark_add_outlined,
          text: "To watch list",
        ),
        const SizedBox(width: 10),
        CustomIconButton(
          onPressed: shareBtnOnPressed,
          icon: Icons.share,
          text: "Share",
        ),
      ],
    );
  }
}
