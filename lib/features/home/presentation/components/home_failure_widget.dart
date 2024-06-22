import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/common/data/app_exceptions.dart';
import 'package:movies_app/common/domain/repositories/repository_failure.dart';
import 'package:movies_app/common/presentation/components/failure_widget.dart';
import 'package:movies_app/features/home/presentation/home_bloc/home_bloc.dart';

class HomeFailureWidget extends StatelessWidget {
  const HomeFailureWidget({
    super.key,
    required this.failure,
  });

  final ApiRepositoryFailure failure;

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
          onPressed: () => context.read<HomeBloc>().add(HomeLoadMediaEvent()),
        );
      default:
        return FailureWidget.unknownError(
          context,
          onPressed: () => context.read<HomeBloc>().add(HomeLoadMediaEvent()),
        );
    }
  }
}
