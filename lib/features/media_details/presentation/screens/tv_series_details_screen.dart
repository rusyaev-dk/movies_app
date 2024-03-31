import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/features/media_details/presentation/blocs/tv_series_details_bloc/tv_series_details_bloc.dart';
import 'package:movies_app/features/media_details/presentation/components/tv_series/tv_series_details_appbar.dart';
import 'package:movies_app/features/media_details/presentation/components/tv_series/tv_series_details_body.dart';
import 'package:movies_app/features/media_details/presentation/cubits/media_details_appbar_cubit/media_details_appbar_cubit.dart';

class TVSeriesDetailsScreen extends StatelessWidget {
  const TVSeriesDetailsScreen({
    super.key,
    required this.tvSeriesId,
    required this.appBarTitle,
  });

  final int tvSeriesId;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => TvSeriesDetailsBloc(
            mediaRepository: RepositoryProvider.of<MediaRepository>(context),
          )..add(TVSeriesDetailsLoadDetailsEvent(tvSeriesId: tvSeriesId)),
        ),
        BlocProvider(
          key: ValueKey([tvSeriesId, appBarTitle]),
          create: (context) => MediaDetailsAppbarCubit(),
        ),
      ],
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: TVSeriesDetailsAppBar(appBarTitle: appBarTitle),
        body: const TVSeriesDetailsBody(),
      ),
    );
  }
}
