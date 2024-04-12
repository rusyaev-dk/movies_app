import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/data/storage/key_value_storage.dart';
import 'package:movies_app/core/domain/repositories/connectivity_repository.dart';
import 'package:movies_app/core/domain/repositories/session_data_repository.dart';
import 'package:movies_app/core/data/storage/secure_storage.dart';
import 'package:movies_app/core/domain/repositories/account_repository.dart';
import 'package:movies_app/core/domain/repositories/key_value_storage_repository.dart';
import 'package:movies_app/core/presentation/blocs/theme_bloc/theme_bloc.dart';
import 'package:movies_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:movies_app/core/routing/app_router.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/core/presentation/cubits/network_cubit/network_cubit.dart';

class MoviesApp extends StatelessWidget {
  const MoviesApp({
    super.key,
    required this.sharedPrefsStorage,
  });

  final KeyValueStorage sharedPrefsStorage;

  @override
  Widget build(BuildContext context) {
    final Connectivity connectivity = Connectivity();
    final SecureStorage secureStorage = SecureStorage();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) =>
              ConnectivityRepository(connectivity: connectivity),
        ),
        RepositoryProvider(
          create: (context) =>
              KeyValueStorageRepository(storage: sharedPrefsStorage),
        ),
        RepositoryProvider(
          create: (context) =>
              SessionDataRepository(secureStorage: secureStorage),
        ),
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => AccountRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeBloc(),
          ),
          BlocProvider(
            create: (context) => NetworkCubit(
              connectivityRepository:
                  RepositoryProvider.of<ConnectivityRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
              accountRepository:
                  RepositoryProvider.of<AccountRepository>(context),
              sessionDataRepository:
                  RepositoryProvider.of<SessionDataRepository>(context),
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
              themeMode: state.themeMode, // поставить ThemeMode.system
            );
          },
        ),
      ),
    );
  }
}
