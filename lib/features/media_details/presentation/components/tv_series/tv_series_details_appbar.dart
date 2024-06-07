import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/media_details/presentation/cubits/media_details_appbar_cubit/media_details_appbar_cubit.dart';

class TVSeriesDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const TVSeriesDetailsAppBar({
    super.key,
    required this.appBarTitle,
  });

  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaDetailsAppbarCubit, MediaDetailsAppbarState>(
      builder: (context, state) {
        final Color appBarColor;
        bool showTitle = false;
        switch (state) {
          case (MediaDetailsAppbarState.filled):
            appBarColor = Theme.of(context).extension<ThemeColors>()!.background;
            showTitle = true;
            break;
          case (MediaDetailsAppbarState.transparent):
            appBarColor = Colors.transparent;
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          padding: appBarTitle.length >= 25
              ? const EdgeInsets.only(left: 5, right: 5, top: 35, bottom: 5)
              : const EdgeInsets.only(left: 5, right: 5, top: 25),
          decoration: BoxDecoration(color: appBarColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(
                  Icons.arrow_back,
                  size: 25,
                ),
              ),
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 450),
                  opacity: showTitle ? 1 : 0,
                  child: Text(
                    appBarTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .headingTextStyle,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.cast,
                  size: 25,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize =>
      Size(double.infinity, appBarTitle.length >= 25 ? 85 : 75);
}
