import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/common/domain/repositories/account_repository.dart';
import 'package:movies_app/common/domain/repositories/session_data_repository.dart';
import 'package:movies_app/common/presentation/cubits/network_cubit/network_cubit.dart';
import 'package:movies_app/features/account/presentation/account_bloc/account_bloc.dart';
import 'package:movies_app/features/account/presentation/components/account_body.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AccountBloc(
        networkCubit: BlocProvider.of<NetworkCubit>(context),
        sessionDataRepository: GetIt.I<SessionDataRepository>(),
        accountRepository: GetIt.I<AccountRepository>(),
      )..add(AccountLoadAccountDetailsEvent()),
      child: const Scaffold(
        body: AccountBody(),
      ),
    );
  }
}
