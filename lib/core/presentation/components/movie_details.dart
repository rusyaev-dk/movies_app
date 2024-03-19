import 'package:flutter/material.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';

class MovieDetailsBody extends StatelessWidget {
  const MovieDetailsBody({
    super.key,
    required this.movie,
  });

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(movie.title!),
    );
  }
}
