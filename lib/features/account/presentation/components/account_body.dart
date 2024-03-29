import 'package:flutter/material.dart';
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
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shimmer/shimmer.dart';

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
          return AccountContent.shimmerLoading(context);
        }

        if (state is AccountLoadedState) {
          return AccountContent(account: state.account);
        }

        return AccountContent.shimmerLoading(context);
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

  static Widget shimmerLoading(BuildContext context) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: Theme.of(context).extension<ThemeGradients>()!.shimmerGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 18,
                    width: 10,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, bottom: 30),
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController =
        RefreshController(initialRefresh: false);

    Widget avatarWidget = ApiImageFormatter.formatAvatarImageWidget(
      context,
      imagePath: account.avatarPath,
      diameter: 200,
    );

    return SmartRefresher(
      enablePullDown: true,
      controller: refreshController,
      onRefresh: () => context.read<AccountBloc>().add(
          AccountRefreshAccountDetailsEvent(
              refreshController: refreshController)),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.surface,
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  avatarWidget,
                  const SizedBox(height: 20),
                  Text(
                    account.username ?? "Unknown username",
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .headingTextStyle
                        .copyWith(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 250,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 25, right: 25, bottom: 30),
            child: AccountSettings(),
          ),
        ],
      ),
    );
  }
}
