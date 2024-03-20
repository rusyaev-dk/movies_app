import 'package:flutter/material.dart';

class ApiMediaVoteFormatter {
  static double formatVoteAverage({required double? voteAverage}) {
    if (voteAverage == null) return 0;
    return double.parse(voteAverage.toStringAsFixed(1));
  }

  static Color getVoteColor({
    required BuildContext context,
    required double voteAverage,
    bool isRounded = false,
  }) {
    final double vote;

    if (!isRounded) {
      vote = formatVoteAverage(voteAverage: voteAverage);
    } else {
      vote = voteAverage;
    }

    final Color voteColor;
    switch (vote) {
      case (0):
        voteColor = Theme.of(context).colorScheme.secondary;
        break;
      case (< 4):
        voteColor = Theme.of(context).colorScheme.error;
        break;
      case (< 7):
        voteColor = Theme.of(context).colorScheme.secondary;
        break;
      case (>= 7):
        voteColor = Theme.of(context).colorScheme.tertiary;
        break;
      default:
        voteColor = Theme.of(context).colorScheme.secondary;
    }
    return voteColor;
  }
}
