import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/presentation/components/custom_buttons.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          CustomRoundedButton(
            borderRadiusDirection: BorderRadiusDirection.onlyTop,
            icon: Icons.colorize_outlined,
            text: "Change theme",
            onPressed: () {
            },
          ),
          Divider(
            height: 1,
            thickness: 1,
            indent: 15,
            color: Theme.of(context).colorScheme.secondary.withAlpha(100),
          ),
          CustomRoundedButton(
            borderRadiusDirection: BorderRadiusDirection.onlyBottom,
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
      ),
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
