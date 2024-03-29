import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/account_repository.dart';
import 'package:movies_app/core/domain/repositories/session_data_repository.dart';
import 'package:movies_app/features/watch_list/presentation/components/watch_list_app_bar.dart';
import 'package:movies_app/features/watch_list/presentation/components/watch_list_body.dart';
import 'package:movies_app/features/watch_list/presentation/watch_list_bloc/watch_list_bloc.dart';

class WatchListScreen extends StatelessWidget {
  const WatchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WatchListBloc(
        sessionDataRepository:
            RepositoryProvider.of<SessionDataRepository>(context),
        accountRepository: RepositoryProvider.of<AccountRepository>(context),
      )..add(WatchListLoadWatchListEvent()),
      child: const Scaffold(
        appBar: WatchListAppBar(),
        body: WatchListBody(),
      ),
    );
  }
}
