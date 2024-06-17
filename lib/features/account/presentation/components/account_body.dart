import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/utils/formatters/image_formatter.dart';
import 'package:movies_app/features/account/presentation/account_bloc/account_bloc.dart';
import 'package:movies_app/features/account/presentation/components/account_failure_widget.dart';
import 'package:movies_app/features/account/presentation/components/account_settings.dart';
import 'package:movies_app/uikit/colors/colors.dart';
import 'package:movies_app/uikit/text/text.dart';
import 'package:shimmer/shimmer.dart';

class AccountBody extends StatelessWidget {
  const AccountBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        final completer = Completer();
        BlocProvider.of<AccountBloc>(context)
            .add(AccountLoadAccountDetailsEvent(completer: completer));
        return completer.future;
      },
      child: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountFailureState) {
            return AccountFailureWidget(failure: state.failure);
          } else if (state is AccountLoadedState) {
            return AccountContent(account: state.account);
          } else {
            return AccountContent.shimmerLoading(context);
          }
        },
      ),
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
      gradient: AppGradients.of(context).shimmerGradient,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
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
              height: 170,
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
    Widget avatarWidget = ApiImageFormatter.formatAvatarImageWidget(
      context,
      imagePath: account.avatarPath,
      diameter: 200,
    );

    final String accountName;
    if (account.name != null) {
      accountName =
          account.name!.trim().isEmpty ? "Unknown name" : account.name!;
    } else {
      accountName = "Unknown name";
    }

    final String accountUsername;
    if (account.username != null) {
      accountUsername = account.username!.trim().isEmpty
          ? "Unknown username"
          : account.username!;
    } else {
      accountUsername = "Unknown username";
    }

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          width: double.infinity,
          height: 400,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                avatarWidget,
                const SizedBox(height: 25),
                Text(
                  accountName,
                  style:
                      AppTextScheme.of(context).headline.copyWith(fontSize: 24),
                ),
                const SizedBox(height: 20),
                Text(
                  accountUsername,
                  style: AppTextScheme.of(context).headline.copyWith(
                        fontSize: 21,
                        color: AppColorScheme.of(context).primary,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 170),
        const Padding(
          padding: EdgeInsets.only(left: 25, right: 25),
          child: AccountSettings(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
