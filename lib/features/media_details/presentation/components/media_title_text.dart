import 'package:flutter/material.dart';
import 'package:movies_app/common/utils/formatters/media_vote_formatter.dart';
import 'package:movies_app/uikit/text/text.dart';

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
            style: AppTextScheme.of(context)
                .headline
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
            style: AppTextScheme.of(context).headline,
          ),
        ),
      ];
    } else {
      children = [
        Text(
          "$roundedVoteAverage",
          style: AppTextScheme.of(context)
              .headline
              .copyWith(color: voteColor, fontSize: 18),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          softWrap: true,
          overflow: TextOverflow.ellipsis,
          maxLines: 4,
          style: AppTextScheme.of(context).headline,
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
