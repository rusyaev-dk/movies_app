import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/media_details/presentation/cubits/media_details_appbar_cubit/media_details_appbar_cubit.dart';
import 'package:movies_app/uikit/text/text.dart';

class PersonDetailsAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const PersonDetailsAppBar({
    super.key,
    required this.appBarTitle,
  });

  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaDetailsAppbarCubit, MediaDetailsAppbarState>(
      builder: (context, state) {
        bool showTitle = false;
        switch (state) {
          case (MediaDetailsAppbarState.filled):
            showTitle = true;
            break;
          case (MediaDetailsAppbarState.transparent):
        }

        return AppBar(
          forceMaterialTransparency: true,
          title: AnimatedOpacity(
            opacity: showTitle ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Text(
              appBarTitle,
              style: AppTextScheme.of(context).headline,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.share))
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, 55);
}
