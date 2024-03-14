import 'package:flutter/material.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/presentation/components/buttons.dart';
import 'package:movies_app/core/themes/theme.dart';

class ExceptionWidget extends StatelessWidget {
  const ExceptionWidget({
    super.key,
    this.onPressed,
    required this.exception,
    required this.icon,
    required this.buttonText,
  });

  final ApiClientException exception;
  final IconData icon;
  final String buttonText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    Widget exceptionButton = CustomGradientButton(
      text: buttonText,
      onPressed: onPressed,
    );

    Widget exceptionIcon = Icon(
      icon,
      size: 160,
      color: Theme.of(context).colorScheme.surface,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            exceptionIcon,
            const SizedBox(height: 20),
            Text(
              exception.getInfo(),
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .headingTextStyle
                  .copyWith(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onBackground,
                  ),
            ),
            const SizedBox(height: 20),
            exceptionButton,
          ],
        ),
      ),
    );
  }
}
