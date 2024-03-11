import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/repositories/session_data_repository.dart';
import 'package:movies_app/core/data/storage/secure_storage.dart';
import 'package:movies_app/core/domain/repositories/account_repository.dart';
import 'package:movies_app/core/domain/repositories/auth_repository.dart';
import 'package:movies_app/core/routing/app_router.dart';
import 'package:movies_app/core/presentation/auth_bloc/auth_bloc.dart';
import 'package:movies_app/core/themes/theme.dart';

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => AccountRepository(),
        ),
        RepositoryProvider(
          create: (context) => MediaRepository(),
        ),
        RepositoryProvider(
          create: (context) =>
              SessionDataRepository(secureStorage: SecureStorage()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
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
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: createLightTheme(),
          darkTheme: createDarkTheme(),
          themeMode: ThemeMode.dark, // поставить ThemeMode.system
        ),
      ),
    );
  }
}
