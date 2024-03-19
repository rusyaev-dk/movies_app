import 'package:flutter/material.dart';
import 'package:movies_app/core/presentation/image_formatter.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/core/utils/service_functions.dart';

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
    ImageProvider<Object> image =
        ApiImageFormatter.formatImageProvider(imagePath: imagePath);

    Widget? stack;
    if (voteAverage != null) {
      final double roundedVoteAverage =
          formatVoteAverage(voteAverage: voteAverage!);

      final Color voteContainerColor = getVoteColor(
        context: context,
        voteAverage: roundedVoteAverage,
        isRounded: true,
      );

      stack = Stack(
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
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: image,
              ),
            ),
            child: stack,
          ),
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
