import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    EdgeInsetsGeometry? padding;
    if (title.length >= 25) {
      padding = const EdgeInsets.symmetric(horizontal: 20);
      children = [
        Expanded(
          child: Text(
            "$roundedVoteAverage",
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .headingTextStyle
                .copyWith(color: voteColor, fontSize: 20),
          ),
        ),
        Expanded(
          flex: 8,
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

    if (padding != null) {
      return Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
