import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/app_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/components/custom_buttons.dart';
import 'package:movies_app/core/presentation/routing/app_routes.dart';
import 'package:movies_app/core/presentation/themes/theme.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';

class FailureWidget extends StatelessWidget {
  const FailureWidget({
    super.key,
    required this.failure,
    this.icon = Icons.error_outline,
    this.onPressed,
    this.buttonText,
  });

  final ApiRepositoryFailure failure;
  final IconData icon;
  final String? buttonText;
  final void Function()? onPressed;

  static Widget sessionExpired(BuildContext context) {
    Widget actionButton = CustomGradientButton(
      text: "Login",
      onPressed: () {
        context.read<AuthBloc>().add(AuthLogoutEvent());
        context.go(AppRoutes.screenLoader);
      },
    );
    return _buildCustom(
      context,
      icon: Icons.logout,
      message: ApiClientExceptionType.sessionExpired.formatMessage(),
      buttonWidget: actionButton,
    );
  }

  static Widget networkError(
    BuildContext context, {
    required void Function() onPressed,
  }) {
    Widget actionButton = CustomGradientButton(
      text: "Update",
      onPressed: onPressed,
    );
    return _buildCustom(
      context,
      icon: Icons.wifi_off,
      message: ApiClientExceptionType.network.formatMessage(),
      buttonWidget: actionButton,
    );
  }

  static Widget unknownError(
    BuildContext context, {
    void Function()? onPressed,
  }) {
    Widget? actionButton;
    if (onPressed != null) {
      actionButton = CustomGradientButton(
        text: "Try again",
        onPressed: onPressed,
      );
    }
    return _buildCustom(
      context,
      icon: Icons.wifi_off,
      message: ApiClientExceptionType.network.formatMessage(),
      buttonWidget: actionButton,
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? exceptionButton;
    if (buttonText != null && onPressed != null) {
      exceptionButton = CustomGradientButton(
        text: buttonText!,
        onPressed: onPressed,
      );
    }

    return _buildCustom(
      context,
      icon: icon,
      message: failure.type.formatMessage(),
      buttonWidget: exceptionButton,
    );
  }

  static Widget _buildCustom(
    BuildContext context, {
    required IconData icon,
    required String message,
    required Widget? buttonWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 160,
              color: Theme.of(context).colorScheme.surface,
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .headingTextStyle
                  .copyWith(
                    fontSize: 18,
                    color: Theme.of(context)
                        .extension<ThemeColors>()!
                        .onBackground,
                  ),
            ),
            const SizedBox(height: 20),
            if (buttonWidget != null) buttonWidget,
          ],
        ),
      ),
    );
  }
}
