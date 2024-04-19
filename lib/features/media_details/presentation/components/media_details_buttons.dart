import 'package:flutter/material.dart';
import 'package:movies_app/core/presentation/components/custom_buttons.dart';

class MediaDetailsButtons extends StatelessWidget {
  const MediaDetailsButtons({
    super.key,
    required this.favouriteBtnOnPressed,
    required this.watchListBtnOnPressed,
    required this.shareBtnOnPressed,
    required this.isFavourite,
    required this.isInWatchlist,
  });

  final bool isFavourite;
  final bool isInWatchlist;
  final void Function() favouriteBtnOnPressed;
  final void Function() watchListBtnOnPressed;
  final void Function() shareBtnOnPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MediaDetailsIconButton(
          onPressed: favouriteBtnOnPressed,
          icon: isFavourite ? Icons.star : Icons.star_border,
          text: "Favourite",
        ),
        const SizedBox(width: 10),
        MediaDetailsIconButton(
          onPressed: watchListBtnOnPressed,
          icon: isInWatchlist ? Icons.bookmark : Icons.bookmark_add_outlined,
          text: "To watch list",
        ),
        const SizedBox(width: 10),
        MediaDetailsIconButton(
          onPressed: () {},
          icon: Icons.share,
          text: "Share",
        ),
      ],
    );
  }
}
