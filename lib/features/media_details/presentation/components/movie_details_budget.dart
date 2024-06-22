import 'package:flutter/material.dart';
import 'package:movies_app/common/utils/formatters/data_formatter.dart';
import 'package:movies_app/uikit/colors/colors.dart';
import 'package:movies_app/uikit/text/text.dart';

class MediaDetailsBudget extends StatelessWidget {
  const MediaDetailsBudget({
    super.key,
    required this.budget,
    required this.revenue,
  });

  final int budget;
  final int revenue;

  @override
  Widget build(BuildContext context) {
    String budgetString = budget > 0
        ? "${DataFormatter.formatNumberWithThousandsSeparator(budget)} \$"
        : 'Unknown';

    String revenueString = revenue > 0
        ? "${DataFormatter.formatNumberWithThousandsSeparator(revenue)} \$"
        : 'Unknown';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Box office",
          style: AppTextScheme.of(context).headline,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: AppColorScheme.of(context).surfaceDarker,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Budget:",
                        style: AppTextScheme.of(context).headline,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        budgetString,
                        maxLines: 1,
                        style: AppTextScheme.of(context)
                            .headline
                            .copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Revenue:",
                        style: AppTextScheme.of(context).headline,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        revenueString,
                        maxLines: 1,
                        style: AppTextScheme.of(context)
                            .headline
                            .copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
