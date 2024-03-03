import 'package:flutter/material.dart';
import 'package:movies_app/core/data/clients/tmdb_image_path_formatter.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';

class SearchTile extends StatelessWidget {
  const SearchTile({super.key, required this.model});

  final TMDBModel model;

  @override
  Widget build(BuildContext context) {
    Widget content = const Placeholder(); // ВРЕМЕННО
    if (model is MovieModel) {
      MovieModel movie = model as MovieModel;
      content = ListTile(
        leading: movie.posterPath != null
            ? Image.network(
                TMDBImageFormatter.formatImageUrl(path: movie.posterPath!),
                fit: BoxFit.cover,
              )
            : Image.asset(
                "assets/images/unknown_film.png",
                fit: BoxFit.cover,
              ),
        title: Text(movie.title!),
        subtitle: Text("${movie.originalTitle}, ${movie.releaseDate}"),
        trailing: Container(
          height: 10,
          width: 10,
          color: Colors.red,
        ),
      );
    } else if (model is TVSeriesModel) {
      TVSeriesModel tvSeries = model as TVSeriesModel;
      content = ListTile(
        leading: tvSeries.posterPath != null
            ? Image.network(
                TMDBImageFormatter.formatImageUrl(path: tvSeries.posterPath!),
                fit: BoxFit.cover,
              )
            : Image.asset(
                "assets/images/unknown_film.png",
                fit: BoxFit.cover,
              ),
        title: Text(tvSeries.name!),
        subtitle: Text(
            "${tvSeries.originalName}, ${tvSeries.firstAirDate} - ${tvSeries.lastAirDate}"),
        trailing: Container(
          height: 10,
          width: 10,
          color: Colors.red,
        ),
      );
    } else if (model is PersonModel) {
      PersonModel person = model as PersonModel;

      content = ListTile(
        leading: person.profilePath != null
            ? Image.network(
                TMDBImageFormatter.formatImageUrl(path: person.profilePath!),
                fit: BoxFit.cover,
              )
            : Image.asset(
                "assets/images/unknown_film.png",
                fit: BoxFit.cover,
              ),
        title: Text(person.name!),
        subtitle: Text("${person.originalName}"),
        trailing: Container(
          height: 10,
          width: 10,
          color: Colors.red,
        ),
      );
    }

    return content;
  }
}
