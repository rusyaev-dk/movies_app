import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/components/failure_widget.dart';
import 'package:movies_app/core/presentation/formatters/image_formatter.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/account/presentation/account_bloc/account_bloc.dart';
import 'package:movies_app/features/account/presentation/components/account_settings.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';

class AccountBody extends StatelessWidget {
  const AccountBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AccountFailureState) {
          switch (state.failure.type) {
            case (ApiClientExceptionType.sessionExpired):
              return FailureWidget(
                  failure: state.failure,
                  buttonText: "Login",
                  icon: Icons.exit_to_app_outlined,
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutEvent());
                    context.go(AppRoutes.screenLoader);
                  });
            case (ApiClientExceptionType.network):
              return FailureWidget(
                failure: state.failure,
                buttonText: "Update",
                icon: Icons.wifi_off,
                onPressed: () => context
                    .read<AccountBloc>()
                    .add(AccountLoadAccountDetailsEvent()),
              );
            default:
              return FailureWidget(
                failure: state.failure,
                onPressed: () => context
                    .read<AccountBloc>()
                    .add(AccountLoadAccountDetailsEvent()),
              );
          }
        }

        if (state is AccountLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AccountLoadedState) {
          return AccountContent(account: state.account);
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class AccountContent extends StatelessWidget {
  const AccountContent({
    super.key,
    required this.account,
  });

  final AccountModel account;

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget = ApiImageFormatter.formatAvatarImageWidget(
      context,
      imagePath: account.avatarPath,
      diameter: 175,
    );

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            avatarWidget,
            const SizedBox(height: 20),
            Text(
              account.username ?? "Unknown username",
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .headingTextStyle,
            ),
            const Spacer(),
            const AccountSettings(),
          ],
        ),
      ),
    );
  }
}
