import 'package:flutter/material.dart';
import 'package:movies_app/uikit/colors/app_color_sheme.dart';
import 'package:movies_app/uikit/text/app_text_sheme.dart';
import 'package:movies_app/common/utils/formatters/data_formatter.dart';

class PersonInfoText extends StatelessWidget {
  const PersonInfoText({
    super.key,
    this.name,
    this.knownForDepartment,
    this.birthday,
    this.deathday,
  });

  final String? name;
  final String? knownForDepartment;
  final String? birthday;
  final String? deathday;

  @override
  Widget build(BuildContext context) {
    String yearsOfLife = "";
    String age = "";
    if (birthday != null) {
      yearsOfLife = DataFormatter.formatDate(birthday!);
      age = "${DataFormatter.calculateAge(birthday!)} years";
    }
    if (deathday != null) {
      yearsOfLife += " - ${DataFormatter.formatDate(deathday!)}";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          name ?? "Unknown name",
          maxLines: 2,
          style: AppTextScheme.of(context).headline.copyWith(fontSize: 25),
        ),
        const SizedBox(height: 15),
        if (knownForDepartment != null)
          Text(
            knownForDepartment!,
            style: AppTextScheme.of(context).label.copyWith(
                  color: AppColorScheme.of(context).secondary,
                  fontSize: 16,
                ),
          ),
        if (knownForDepartment != null) const SizedBox(height: 8),
        if (yearsOfLife.isNotEmpty)
          Text(
            yearsOfLife,
            style: AppTextScheme.of(context).label.copyWith(
                  color: AppColorScheme.of(context).secondary,
                  fontSize: 16,
                ),
          ),
        if (yearsOfLife.isNotEmpty) const SizedBox(height: 8),
        if (age.isNotEmpty)
          Text(
            age,
            style: AppTextScheme.of(context).label.copyWith(
                  color: AppColorScheme.of(context).secondary,
                  fontSize: 16,
                ),
          ),
        // if (age.isNotEmpty) const SizedBox(height: 8),
      ],
    );
  }
}
