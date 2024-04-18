import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/app_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/components/failure_widget.dart';
import 'package:movies_app/features/media_details/presentation/blocs/movie_details_bloc/movie_details_bloc.dart';

class MovieDetailsFailureWidget extends StatelessWidget {
  const MovieDetailsFailureWidget({
    super.key,
    required this.failure,
    required this.movieId,
  });

  final ApiRepositoryFailure failure;
  final int? movieId;

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
              context.read<MovieDetailsBloc>().add(MovieDetailsLoadDetailsEvent(
                    movieId: movieId!,
                  )),
        );
      default:
        return FailureWidget.unknownError(context);
    }
  }
}
