import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/common/data/app_exceptions.dart';
import 'package:movies_app/common/domain/repositories/repository_failure.dart';
import 'package:movies_app/common/presentation/components/failure_widget.dart';
import 'package:movies_app/features/search/presentation/blocs/search_bloc/search_bloc.dart';

class SearchFailureWidget extends StatelessWidget {
  const SearchFailureWidget({
    super.key,
    required this.failure,
    required this.query,
  });

  final ApiRepositoryFailure failure;
  final String? query;

  @override
  Widget build(BuildContext context) {
    switch (failure.$3) {
      case ApiClientExceptionType.sessionExpired:
        return FailureWidget.sessionExpired(context);
      case ApiClientExceptionType.network:
        return FailureWidget.networkError(
          context,
          onPressed: () =>
              context.read<SearchBloc>().add(SearchMediaEvent(query: query!)),
        );
      default:
        return FailureWidget.unknownError(context);
    }
  }
}
