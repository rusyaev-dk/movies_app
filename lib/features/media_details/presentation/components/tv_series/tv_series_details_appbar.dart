import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/features/media_details/presentation/blocs/tv_series_details_bloc/tv_series_details_bloc.dart';

class TVSeriesDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TVSeriesDetailsAppBar({
    super.key,
    required this.tvSeriesId,
  });

  final int tvSeriesId;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
            onPressed: () {
              context
                  .read<TvSeriesDetailsBloc>()
                  .add(TVSeriesDetailsLoadDetailsEvent(tvSeriesId: tvSeriesId));
            },
            icon: const Icon(Icons.star_border))
      ],
    );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size(double.infinity, 75);
}
