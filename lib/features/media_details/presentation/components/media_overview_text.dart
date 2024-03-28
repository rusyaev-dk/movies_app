import 'package:flutter/material.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/core/utils/data_formatter.dart';

class MediaOverviewText extends StatelessWidget {
  const MediaOverviewText({
    super.key,
    required this.overview,
  });

  final String? overview;

  static Widget shimmerLoading() {
    return Column(
      children: [
        Container(
          height: 14,
          width: double.infinity,
          color: Colors.white,
        ),
        const SizedBox(height: 6),
        Container(
          height: 14,
          width: double.infinity,
          color: Colors.white,
        ),
        const SizedBox(height: 6),
        Container(
          height: 14,
          width: double.infinity,
          color: Colors.white,
        ),
        const SizedBox(height: 6),
        Container(
          height: 14,
          width: double.infinity,
          color: Colors.white,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (overview == null) {
      return Center(
        child: Text(
          "No overview",
          style:
              Theme.of(context).extension<ThemeTextStyles>()!.headingTextStyle,
        ),
      );
    }

    if (DataFormatter.countSentences(overview!) <= 1) {
      return Text(
        overview!,
        style: Theme.of(context)
            .extension<ThemeTextStyles>()!
            .subtitleTextStyle
            .copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
      );
    }
    String firstSentense = overview!.substring(0, overview!.indexOf('.') + 1);
    String otherSensetnses = overview!.substring(overview!.indexOf('.') + 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          firstSentense,
          style: Theme.of(context)
              .extension<ThemeTextStyles>()!
              .subtitleTextStyle
              .copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
        ),
        const SizedBox(height: 15),
        Text(
          otherSensetnses,
          style:
              Theme.of(context).extension<ThemeTextStyles>()!.subtitleTextStyle,
        ),
      ],
    );
  }
}
