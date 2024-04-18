import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/presentation/formatters/image_formatter.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/account/presentation/account_bloc/account_bloc.dart';
import 'package:movies_app/features/account/presentation/components/account_failure_widget.dart';
import 'package:movies_app/features/account/presentation/components/account_settings.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:shimmer/shimmer.dart';

class AccountBody extends StatelessWidget {
  const AccountBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
      builder: (context, state) {
        if (state is AccountFailureState) {
          return AccountFailureWidget(failure: state.failure);
        } else if (state is AccountLoadedState) {
          return AccountContent(account: state.account);
        } else {
          return AccountContent.shimmerLoading(context);
        }
      },
    );
  }
}

class AccountContent extends StatefulWidget {
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
              height: 100,
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
  State<AccountContent> createState() => _AccountContentState();
}

class _AccountContentState extends State<AccountContent> {
  late final RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget = ApiImageFormatter.formatAvatarImageWidget(
      context,
      imagePath: widget.account.avatarPath,
      diameter: 200,
    );

    return SmartRefresher(
      enablePullDown: true,
      controller: _refreshController,
      onRefresh: () => context.read<AccountBloc>().add(
          AccountRefreshAccountDetailsEvent(
              refreshController: _refreshController)),
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
                    widget.account.username ?? "Unknown username",
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
            height: 170,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 25, right: 25),
            child: AccountSettings(),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
