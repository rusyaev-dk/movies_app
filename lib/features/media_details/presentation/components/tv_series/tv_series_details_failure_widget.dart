import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/app_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/components/failure_widget.dart';
import 'package:movies_app/features/media_details/presentation/blocs/tv_series_details_bloc/tv_series_details_bloc.dart';

class TvSeriesDetailsFailureWidget extends StatelessWidget {
  const TvSeriesDetailsFailureWidget({
    super.key,
    required this.failure,
    required this.tvSeriesId,
  });

  final ApiRepositoryFailure failure;
  final int? tvSeriesId;

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
          onPressed: () =>
               context
              .read<TVSeriesDetailsBloc>()
              .add(TVSeriesDetailsLoadDetailsEvent(
                tvSeriesId: tvSeriesId!,
              )),
        );
      default:
        return FailureWidget.unknownError(context);
    }
  }
}
