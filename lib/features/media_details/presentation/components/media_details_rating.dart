import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movies_app/common/presentation/components/media/media_vote.dart';
import 'package:movies_app/common/utils/formatters/media_vote_formatter.dart';
import 'package:movies_app/uikit/colors/colors.dart';
import 'package:movies_app/uikit/text/text.dart';

class MediaDetailsRating extends StatelessWidget {
  const MediaDetailsRating({
    super.key,
    required this.voteAverage,
    required this.voteCount,
  });

  final double voteAverage;
  final int voteCount;

  @override
  Widget build(BuildContext context) {
    final double roundedVoteAverage =
        ApiMediaVoteFormatter.formatVoteAverage(voteAverage: voteAverage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rating",
          style: AppTextScheme.of(context).headline,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: AppColorScheme.of(context).surfaceDarker,
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: RadialPercentWidget(
                  percent: voteAverage * 10 / 100,
                  fillColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  lineColor: Theme.of(context).colorScheme.primary,
                  freeColor:
                      Theme.of(context).colorScheme.primary.withAlpha(85),
                  lineWidth: 5,
                  child: Text(
                    "${(roundedVoteAverage * 10).toInt()}%",
                    style: AppTextScheme.of(context).headline,
                  ),
                ),
              ),
              Expanded(
                child: MediaVoteAdditionalInfo(
                  roundedVoteAverage: roundedVoteAverage,
                  voteCount: voteCount,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class RadialPercentWidget extends StatelessWidget {
  final Widget child;
  final double percent;
  final Color fillColor;
  final Color lineColor;
  final Color freeColor;
  final double lineWidth;

  const RadialPercentWidget({
    super.key,
    required this.child,
    required this.percent,
    required this.fillColor,
    required this.lineColor,
    required this.freeColor,
    required this.lineWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: _RadialPercentPainter(
            percent: percent,
            fillColor: fillColor,
            lineColor: lineColor,
            freeColor: freeColor,
            lineWidth: lineWidth,
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.all(lineWidth * 1.5),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _RadialPercentPainter extends CustomPainter {
  final double percent;
  final Color fillColor;
  final Color lineColor;
  final Color freeColor;
  final double lineWidth;

  _RadialPercentPainter({
    required this.percent,
    required this.fillColor,
    required this.lineColor,
    required this.freeColor,
    required this.lineWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = _calculateCirclesRect(size);
    _darwBackground(canvas, rect);
    _darwFreeSpace(canvas, rect);
    _darwFiledSpace(canvas, rect);
  }

  void _darwBackground(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawOval(rect, paint);
  }

  void _darwFiledSpace(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    paint.strokeWidth = lineWidth;

    canvas.drawArc(
      rect,
      _radians(-90),
      _radians(360 * percent),
      false,
      paint,
    );
  }

  void _darwFreeSpace(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = freeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = lineWidth;

    canvas.drawArc(
      rect,
      _radians(360 * percent - 90),
      _radians(360 * (1.0 - percent)),
      false,
      paint,
    );
  }

  double _radians(double degrees) {
    return degrees * pi / 180;
  }

  Rect _calculateCirclesRect(Size size) {
    final offset = lineWidth / 2;
    final rect = Offset(offset, offset) &
        Size(size.width - lineWidth, size.height - lineWidth);
    return rect;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
