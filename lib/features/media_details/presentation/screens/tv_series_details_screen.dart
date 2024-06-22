import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/common/domain/repositories/account_repository.dart';
import 'package:movies_app/common/domain/repositories/media_repository.dart';
import 'package:movies_app/common/domain/repositories/session_data_repository.dart';
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
          create: (context) => TVSeriesDetailsBloc(
            sessionDataRepository: GetIt.I<SessionDataRepository>(),
            accountRepository: GetIt.I<AccountRepository>(),
            mediaRepository: GetIt.I<MediaRepository>(),
          )..add(TVSeriesDetailsLoadDetailsEvent(tvSeriesId: tvSeriesId)),
        ),
        BlocProvider(
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
