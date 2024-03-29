import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/watch_list/presentation/watch_list_bloc/watch_list_bloc.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class NoAddedWatchListMedia extends StatelessWidget {
  const NoAddedWatchListMedia({super.key});

  @override
  Widget build(BuildContext context) {
    RefreshController refreshController =
        RefreshController(initialRefresh: false);

    return SmartRefresher(
      enablePullDown: true,
      controller: refreshController,
      onRefresh: () => context.read<WatchListBloc>().add(
          WatchListRefreshWatchListEvent(refreshController: refreshController)),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmark_border,
              size: 160,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(height: 20),
            Text(
              "You haven't added anything to your watch list yet",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .headingTextStyle
                  .copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
