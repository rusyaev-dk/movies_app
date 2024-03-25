import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/account_repository.dart';
import 'package:movies_app/core/domain/repositories/session_data_repository.dart';
import 'package:movies_app/features/account/presentation/account_bloc/account_bloc.dart';
import 'package:movies_app/features/account/presentation/components/account_body.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountBloc(
        sessionDataRepository:
            RepositoryProvider.of<SessionDataRepository>(context),
        accountRepository: RepositoryProvider.of<AccountRepository>(context),
      )..add(AccountLoadAccountDetailsEvent()),
      child: Scaffold(
        appBar: AppBar(),
        body: const AccountBody(),
      ),
    );
  }
}
