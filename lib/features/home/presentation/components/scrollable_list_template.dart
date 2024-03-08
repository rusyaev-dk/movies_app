import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/features/home/presentation/components/list_title.dart';
import 'package:movies_app/features/home/presentation/components/listview_implementations.dart';

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

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTitle(
            title: title,
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: cardHeight,
            width: double.infinity,
            child: listView,
          ),
        ],
      ),
    );
  }
}
