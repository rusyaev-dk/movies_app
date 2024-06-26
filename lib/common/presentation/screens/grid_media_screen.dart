import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/common/domain/repositories/media_repository.dart';
import 'package:movies_app/common/presentation/components/media/grid_media_appbar.dart';
import 'package:movies_app/common/presentation/components/media/grid_media_body.dart';
import 'package:movies_app/common/presentation/blocs/grid_media_bloc/grid_media_bloc.dart';

class GridMediaScreen extends StatelessWidget {
  GridMediaScreen({
    super.key,
    required String queryTypeStr,
  }) : queryType = ApiMediaQueryTypeX.fromString(queryTypeStr);

  final ApiMediaQueryType queryType;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GridMediaBloc(
        mediaRepository: GetIt.I<MediaRepository>(),
      )..add(GridMediaLoadNewMediaEvent(queryType: queryType)),
      child: Scaffold(
        appBar: GridMediaAppBar(queryType: queryType),
        body: GridMediaBody(queryType: queryType),
      ),
    );
  }
}
