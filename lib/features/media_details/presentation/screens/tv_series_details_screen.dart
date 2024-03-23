import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/features/media_details/presentation/blocs/tv_series_details_bloc/tv_series_details_bloc.dart';
import 'package:movies_app/features/media_details/presentation/components/tv_series/tv_series_details_appbar.dart';
import 'package:movies_app/features/media_details/presentation/components/tv_series/tv_series_details_body.dart';

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
    return BlocProvider(
      create: (context) => TvSeriesDetailsBloc(
        mediaRepository: RepositoryProvider.of<MediaRepository>(context),
      )..add(TVSeriesDetailsLoadDetailsEvent(tvSeriesId: tvSeriesId)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: TVSeriesDetailsAppBar(tvSeriesId: tvSeriesId),
        body: const TVSeriesDetailsBody(),
      ),
    );
  }
}
