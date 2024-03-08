import 'package:flutter/material.dart';
import 'package:movies_app/core/data/clients/tmdb_image_path_formatter.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    this.imageUrl,
    required this.voteAverage,
    required this.width,
  });

  final String? imageUrl;
  final double voteAverage;
  final double width;

  @override
  Widget build(BuildContext context) {
    final double roundedVoteAverage =
        double.parse(voteAverage.toStringAsFixed(1));

    final Color voteContainerColor;

    switch (roundedVoteAverage) {
      case (< 4):
        voteContainerColor = Theme.of(context).colorScheme.error;
        break;
      case (< 7):
        voteContainerColor = Theme.of(context).colorScheme.surface;
        break;
      case (>= 7):
        voteContainerColor = Theme.of(context).colorScheme.tertiary;
        break;
      default:
        voteContainerColor = Theme.of(context).colorScheme.surface;
    }

    return Container(
      width: width,
      decoration: BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.cover,
          image: imageUrl != null
              ? NetworkImage(
                  TMDBImageFormatter.formatImageUrl(path: imageUrl!),
                ) as ImageProvider<Object>
              : const AssetImage(
                  "assets/images/unknown_film.png",
                ),
        ),
      ),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(3),
            padding: const EdgeInsets.all(3),
            height: 23,
            width: 35,
            color: voteContainerColor,
            child: Center(
              child: Text(
                "$roundedVoteAverage",
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
