import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/home/presentation/components/list_title.dart';
import 'package:movies_app/features/home/presentation/components/listview_implementations.dart';
import 'package:shimmer/shimmer.dart';

class CustomMediaScrollList extends StatelessWidget {
  const CustomMediaScrollList({
    super.key,
    required this.models,
    required this.title,
    this.cardWidth = 100,
    this.cardHeight = 150,
  });

  final List<TMDBModel> models;
  final String title;
  final double cardWidth;
  final double cardHeight;

  @override
  Widget build(BuildContext context) {
    Widget listView = const Placeholder(); // ВРЕМЕННО

    listView = MediaListView(
      models: models,
      cardWidth: cardWidth,
    );
    
    if (title.isEmpty) {
      return Shimmer(
        direction: ShimmerDirection.ltr,
        gradient:
            Theme.of(context).extension<ThemeGradients>()!.shimmerGradient,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTitle(
              title: title,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: cardHeight,
              width: double.infinity,
              child: listView,
            ),
          ],
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTitle(
          title: title,
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: cardHeight,
          width: double.infinity,
          child: listView,
        ),
      ],
    );
  }
}
