import 'package:flutter/material.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/core/utils/formatters/data_formatter.dart';

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
          style:
              Theme.of(context).extension<ThemeTextStyles>()!.headingTextStyle,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          color: Theme.of(context).extension<ThemeColors>()!.surfaceDarker,
          child: Center(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Budget:",
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .headingTextStyle,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        budgetString,
                        maxLines: 1,
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .headingTextStyle
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
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .headingTextStyle,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        revenueString,
                        maxLines: 1,
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .headingTextStyle
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
