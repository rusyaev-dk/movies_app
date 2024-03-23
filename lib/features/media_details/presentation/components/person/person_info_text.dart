import 'package:flutter/material.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/core/utils/service_functions.dart';

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
      yearsOfLife = formatDate(birthday!);
      age = "${calculateAge(birthday!)} years";
    }
    if (deathday != null) {
      yearsOfLife += "- ${formatDate(deathday!)}";
    }

    return Column(
      children: [
        Text(
          name ?? "Unknown name",
          style:
              Theme.of(context).extension<ThemeTextStyles>()!.headingTextStyle,
        ),
        const SizedBox(height: 8),
        if (knownForDepartment != null)
          Text(
            knownForDepartment!,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .subtitleTextStyle,
          ),
        if (knownForDepartment != null) const SizedBox(height: 8),
        if (yearsOfLife.isNotEmpty)
          Text(
            yearsOfLife,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .subtitleTextStyle,
          ),
        if (yearsOfLife.isNotEmpty) const SizedBox(height: 8),
        if (age.isNotEmpty)
          Text(
            age,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .subtitleTextStyle,
          ),
        // if (age.isNotEmpty) const SizedBox(height: 8),
      ],
    );
  }
}
