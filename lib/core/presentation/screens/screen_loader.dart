import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:movies_app/core/presentation/cubits/screen_loader_cubit/screen_loader_cubit.dart';
import 'package:movies_app/core/routing/app_routes.dart';

class ScreenLoader extends StatelessWidget {
  const ScreenLoader({super.key});

  void _onScreenLoaderBlocStateChanged(
    BuildContext context,
    ScreenLoaderState state,
  ) {
    final String nextScreen =
        state == ScreenLoaderState.authorized ? AppRoutes.home : AppRoutes.auth;
    context.go(nextScreen);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ScreenLoaderCubit(
        initialState: ScreenLoaderState.unknown,
        authBloc: BlocProvider.of<AuthBloc>(context),
      ),
      child: BlocListener<ScreenLoaderCubit, ScreenLoaderState>(
        listenWhen: (prev, current) => current != ScreenLoaderState.unknown,
        listener: _onScreenLoaderBlocStateChanged,
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
