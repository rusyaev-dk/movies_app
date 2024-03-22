import 'package:flutter/material.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/components/custom_buttons.dart';
import 'package:movies_app/core/themes/theme.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget({
    super.key,
    this.onPressed,
    required this.failure,
    this.icon = Icons.error_outline,
    this.buttonText = "Update",
  });

  final RepositoryFailure failure;
  final IconData icon;
  final String buttonText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    String failureText;
    switch (failure.type) {
      case (ApiClientExceptionType.network):
        failureText =
            "Something is wrong with the Internet. Check your connection and try to update";
        break;
      case (ApiClientExceptionType.sessionExpired):
        failureText = "Your account session has expired";
        break;
      case (ApiClientExceptionType.jsonKey):
        failureText = "Oops... Something went wrong. Please try again";
        break;
      default:
        failureText = "Oops... Unknown error. Please try again";
        break;
    }

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
              failureText,
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
