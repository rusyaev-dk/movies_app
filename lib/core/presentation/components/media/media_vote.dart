import 'package:flutter/material.dart';
import 'package:movies_app/core/utils/formatters/media_vote_formatter.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/core/utils/formatters/data_formatter.dart';

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

class MediaVoteAdditionalInfo extends StatelessWidget {
  const MediaVoteAdditionalInfo({
    super.key,
    required this.roundedVoteAverage,
    required this.voteCount,
  });

  final double roundedVoteAverage;
  final int voteCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "$roundedVoteAverage",
          style: Theme.of(context)
              .extension<ThemeTextStyles>()!
              .headingTextStyle
              .copyWith(
                fontSize: 30,
                color: ApiMediaVoteFormatter.getVoteColor(
                  context: context,
                  voteAverage: roundedVoteAverage,
                  isRounded: true,
                ),
              ),
        ),
        const SizedBox(height: 8),
        Text(
          "${DataFormatter.formatNumberWithThousandsSeparator(voteCount)} ${voteCount > 1 ? 'votes' : 'vote'}" ,
          style: Theme.of(context)
              .extension<ThemeTextStyles>()!
              .headingTextStyle
              .copyWith(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 18,
              ),
        ),
      ],
    );
  }
}
