import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/common/data/app_exceptions.dart';
import 'package:movies_app/common/domain/repositories/media_repository.dart';
import 'package:movies_app/common/domain/repositories/repository_failure.dart';
import 'package:movies_app/common/presentation/blocs/grid_media_bloc/grid_media_bloc.dart';
import 'package:movies_app/common/presentation/components/failure_widget.dart';

class GridMediaFailureWidget extends StatelessWidget {
  const GridMediaFailureWidget({
    super.key,
    required this.failure,
    required this.queryType,
  });

  final ApiRepositoryFailure failure;
  final ApiMediaQueryType queryType;

  @override
  Widget build(BuildContext context) {
    switch (failure.$3) {
      case ApiClientExceptionType.sessionExpired:
        return FailureWidget.sessionExpired(context);
      case ApiClientExceptionType.invalidId:
        return FailureWidget(
          failure: failure,
          buttonText: "Go back",
          onPressed: () => context.pop(),
        );
      case ApiClientExceptionType.network:
        return FailureWidget.networkError(
          context,
          onPressed: () => context
              .read<GridMediaBloc>()
              .add(GridMediaLoadNewMediaEvent(queryType: queryType)),
        );
      default:
        return FailureWidget.unknownError(
          context,
          onPressed: () => context
              .read<GridMediaBloc>()
              .add(GridMediaLoadNewMediaEvent(queryType: queryType)),
        );
    }
  }
}
