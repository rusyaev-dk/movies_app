import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/presentation/components/media/grid_media_appbar.dart';
import 'package:movies_app/core/presentation/components/media/grid_media_body.dart';
import 'package:movies_app/core/presentation/blocs/grid_media_bloc/grid_media_bloc.dart';

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
        mediaRepository: RepositoryProvider.of<MediaRepository>(context),
      )..add(GridMediaLoadNewMediaEvent(queryType: queryType)),
      child: Scaffold(
        appBar: GridMediaAppBar(queryType: queryType),
        body: GridMediaBody(queryType: queryType),
      ),
    );
  }
}
