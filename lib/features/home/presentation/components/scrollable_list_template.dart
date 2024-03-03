import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/features/home/presentation/components/listview_implementations.dart';


class CustomScrollList<T> extends StatelessWidget {
  const CustomScrollList({
    super.key,
    required this.models,
    required this.text,
    this.cardWidth = 100,
    this.listHeight = 200,
  });

  final List<T> models;
  final String text;
  final double cardWidth;
  final double listHeight;

  @override
  Widget build(BuildContext context) {
    Widget listView = const Placeholder(); // ВРЕМЕННО
    if (T == MovieModel) {
      listView = MoviesListView(
        movies: models as List<MovieModel>,
        cardWidth: cardWidth,
      );
    } else {
      listView = TVSeriesListView(
        tvSeries: models as List<TVSeriesModel>,
        cardWidth: cardWidth,
      );
    }
    return SizedBox(
      height: listHeight,
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Text(text, style: const TextStyle(color: Colors.black),),
              const Text("All", style: TextStyle(color: Colors.black),)
            ],
          ),
          Expanded(child: listView),
        ],
      ),
    );
  }
}
