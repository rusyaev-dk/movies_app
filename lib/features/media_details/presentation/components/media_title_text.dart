import 'package:flutter/material.dart';
import 'package:movies_app/core/presentation/formatters/media_vote_formatter.dart';
import 'package:movies_app/core/themes/theme.dart';

class MediaTitleText extends StatelessWidget {
  const MediaTitleText({
    super.key,
    required this.voteAverage,
    required this.title,
  });

  final double voteAverage;
  final String title;

  @override
  Widget build(BuildContext context) {
    final double roundedVoteAverage =
        ApiMediaVoteFormatter.formatVoteAverage(voteAverage: voteAverage);

    final Color voteColor = ApiMediaVoteFormatter.getVoteColor(
      context: context,
      voteAverage: roundedVoteAverage,
      isRounded: true,
    );

    List<Widget> children;
    if (title.length >= 25) {
      children = [
        Text(
          "$roundedVoteAverage",
          style: Theme.of(context)
              .extension<ThemeTextStyles>()!
              .headingTextStyle
              .copyWith(color: voteColor, fontSize: 20),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .headingTextStyle,
          ),
        ),
      ];
    } else {
      children = [
        Text(
          "$roundedVoteAverage",
          style: Theme.of(context)
              .extension<ThemeTextStyles>()!
              .headingTextStyle
              .copyWith(color: voteColor, fontSize: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 4,
          style:
              Theme.of(context).extension<ThemeTextStyles>()!.headingTextStyle,
        ),
      ];
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
