import 'package:flutter/material.dart';
import 'package:movies_app/core/presentation/components/media/media_vote.dart';
import 'package:movies_app/core/presentation/formatters/image_formatter.dart';
import 'package:movies_app/core/themes/theme.dart';

class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.width,
    this.voteAverage,
    this.imagePath,
    this.cardText,
  });

  final String? imagePath;
  final String? cardText;
  final double? voteAverage;
  final double width;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = ApiImageFormatter.formatImageWidget(
      context,
      imagePath: imagePath,
      width: width,
    );

    Widget child;
    if (voteAverage != null) {
      child = Stack(
        children: [
          SizedBox(
            width: width,
            child: imageWidget,
          ),
          MediaVoteWidget(voteAverage: voteAverage!),
        ],
      );
    } else {
      child = imageWidget;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: child,
        ),
        if (cardText != null) const SizedBox(height: 10),
        if (cardText != null)
          SizedBox(
            width: width,
            child: Text(
              cardText!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .subtitleTextStyle,
            ),
          ),
      ],
    );
  }
}
