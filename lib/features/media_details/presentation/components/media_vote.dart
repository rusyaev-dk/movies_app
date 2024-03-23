import 'package:flutter/material.dart';
import 'package:movies_app/core/presentation/formatters/media_vote_formatter.dart';

class MediaVoteWidget extends StatelessWidget {
  const MediaVoteWidget({
    super.key,
    required this.voteAverage,
    this.height = 23,
    this.width = 25,
  });

  final double height;
  final double width;
  final double voteAverage;

  @override
  Widget build(BuildContext context) {
    final double roundedVoteAverage =
        ApiMediaVoteFormatter.formatVoteAverage(voteAverage: voteAverage);

    final Color voteContainerColor = ApiMediaVoteFormatter.getVoteColor(
      context: context,
      voteAverage: roundedVoteAverage,
      isRounded: true,
    );

    return Container(
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
    );
  }
}
