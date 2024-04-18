import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/data/app_exceptions.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/components/failure_widget.dart';
import 'package:movies_app/features/account/presentation/account_bloc/account_bloc.dart';

class AccountFailureWidget extends StatelessWidget {
  const AccountFailureWidget({
    super.key,
    required this.failure,
  });

  final ApiRepositoryFailure failure;

  @override
  Widget build(BuildContext context) {
    switch (failure.$3) {
      case ApiClientExceptionType.sessionExpired:
        return FailureWidget.sessionExpired(context);
      case ApiClientExceptionType.network:
        return FailureWidget.networkError(
          context,
          onPressed: () =>
              context.read<AccountBloc>().add(AccountLoadAccountDetailsEvent()),
        );
      default:
        return FailureWidget.unknownError(
          context,
          onPressed: () =>
              context.read<AccountBloc>().add(AccountLoadAccountDetailsEvent()),
        );
    }
  }
}
