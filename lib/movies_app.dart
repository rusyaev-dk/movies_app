import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/core/data/storage/shared_prefs_storage.dart';
import 'package:movies_app/core/domain/repositories/connectivity_repository.dart';
import 'package:movies_app/core/domain/repositories/session_data_repository.dart';
import 'package:movies_app/core/domain/repositories/account_repository.dart';
import 'package:movies_app/core/presentation/blocs/theme_bloc/theme_bloc.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/core/routing/app_router.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/core/presentation/cubits/network_cubit/network_cubit.dart';

class MoviesApp extends StatelessWidget {
  const MoviesApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(
            keyValueStorage: GetIt.I<SharedPrefsStorage>(),
          )..add(ThemeRestoreThemeEvent()),
        ),
        BlocProvider(
          create: (context) => NetworkCubit(
            connectivityRepository: GetIt.I<ConnectivityRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: GetIt.I<AuthRepository>(),
            accountRepository: GetIt.I<AccountRepository>(),
            sessionDataRepository: GetIt.I<SessionDataRepository>(),
          ),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            theme: createLightTheme(),
            darkTheme: createDarkTheme(),
            themeMode: state.themeMode,
          );
        },
      ),
    );
  }
}
