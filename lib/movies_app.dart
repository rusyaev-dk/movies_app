import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/tmdb_media_repository.dart';
import 'package:movies_app/core/domain/repositories/tmdb_session_data_repository.dart';
import 'package:movies_app/core/data/storage/secure_storage.dart';
import 'package:movies_app/core/domain/repositories/tmdb_account_repository.dart';
import 'package:movies_app/core/domain/repositories/tmdb_auth_repository.dart';
import 'package:movies_app/core/routing/app_router.dart';
import 'package:movies_app/core/presentation/auth_bloc/auth_bloc.dart';

class MoviesApp extends StatelessWidget {
  const MoviesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => TMDBAuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => TMDBAccountRepository(),
        ),
        RepositoryProvider(
          create: (context) => TMDBMediaRepository(),
        ),
        RepositoryProvider(
          create: (context) =>
              TMDBSessionDataRepository(secureStorage: SecureStorage()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              tmdbAuthRepository:
                  RepositoryProvider.of<TMDBAuthRepository>(context),
              tmdbAccountRepository:
                  RepositoryProvider.of<TMDBAccountRepository>(context),
              tmdbSessionDataRepository:
                  RepositoryProvider.of<TMDBSessionDataRepository>(context),
            ),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
