import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/core/domain/repositories/account_repository.dart';
import 'package:movies_app/core/domain/repositories/session_data_repository.dart';
import 'package:movies_app/core/presentation/cubits/network_cubit/network_cubit.dart';
import 'package:movies_app/features/watchlist/presentation/components/watchlist_appbar.dart';
import 'package:movies_app/features/watchlist/presentation/components/watchlist_body.dart';
import 'package:movies_app/features/watchlist/presentation/watchlist_bloc/watchlist_bloc.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WatchlistBloc(
        networkCubit: BlocProvider.of<NetworkCubit>(context),
        sessionDataRepository: GetIt.I<SessionDataRepository>(),
        accountRepository: GetIt.I<AccountRepository>(),
      )..add(WatchlistloadWatchlistEvent()),
      child: const Scaffold(
        appBar: WatchlistAppBar(),
        body: WatchlistBody(),
      ),
    );
  }
}
