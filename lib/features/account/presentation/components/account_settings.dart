import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/presentation/blocs/theme_bloc/theme_bloc.dart';
import 'package:movies_app/core/presentation/components/custom_buttons.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SwitchThemeButtonsRow(),
        const SizedBox(height: 20),
        CustomRoundedButton(
          borderRadiusDirection: BorderRadiusDirection.all,
          icon: Icons.logout,
          text: "Logout",
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LogoutConfirmationDialog(
                  onConfirm: () {
                    context.read<AuthBloc>().add(AuthLogoutEvent());
                    context.go(AppRoutes.screenLoader);
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class SwitchThemeButtonsRow extends StatelessWidget {
  const SwitchThemeButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              flex: 2,
              child: CustomThemeSwitchButton(
                height: 95,
                color: state.themeMode == ThemeMode.system
                    ? Theme.of(context)
                        .extension<ThemeColors>()!
                        .activatedFilterButtonColor
                    : Theme.of(context).extension<ThemeColors>()!.surfaceDarker,
                borderColor: state.themeMode == ThemeMode.system
                    ? Theme.of(context).colorScheme.primary
                    : null,
                text: "System",
                subtitle: "Same as on the device",
                onPressed: () {
                  context.read<ThemeBloc>().add(ThemeToggleSystemThemeEvent());
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: CustomThemeSwitchButton(
                height: 95,
                icon: Icons.nightlight_round_outlined,
                color: state.themeMode == ThemeMode.dark
                    ? Theme.of(context)
                        .extension<ThemeColors>()!
                        .activatedFilterButtonColor
                    : Theme.of(context).extension<ThemeColors>()!.surfaceDarker,
                borderColor: state.themeMode == ThemeMode.dark
                    ? Theme.of(context).colorScheme.primary
                    : null,
                text: "Dark",
                onPressed: () {
                  context.read<ThemeBloc>().add(ThemeToggleDarkThemeEvent());
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: CustomThemeSwitchButton(
                height: 95,
                icon: Icons.sunny,
                color: state.themeMode == ThemeMode.light
                    ? Theme.of(context)
                        .extension<ThemeColors>()!
                        .activatedFilterButtonColor
                    : Theme.of(context).extension<ThemeColors>()!.surfaceDarker,
                borderColor: state.themeMode == ThemeMode.light
                    ? Theme.of(context).colorScheme.primary
                    : null,
                text: "Light",
                onPressed: () {
                  context.read<ThemeBloc>().add(ThemeToggleLightThemeEvent());
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class LogoutConfirmationDialog extends StatelessWidget {
  final void Function() onConfirm;

  const LogoutConfirmationDialog({super.key, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Logout",
        style: Theme.of(context).extension<ThemeTextStyles>()!.headingTextStyle,
      ),
      content: Text(
        "Are you sure you want to logout?",
        style: Theme.of(context)
            .extension<ThemeTextStyles>()!
            .subtitleTextStyle
            .copyWith(fontSize: 17),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(
            "Logout",
            style: TextStyle(
              color: Theme.of(context).extension<ThemeColors>()!.onBackground,
            ),
          ),
        ),
      ],
    );
  }
}
