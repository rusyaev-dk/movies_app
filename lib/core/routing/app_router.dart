import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/presentation/screens/error_screens.dart';
import 'package:movies_app/features/account/presentation/screens/account_screen.dart';
import 'package:movies_app/features/watch_list/presentation/screens/watch_list_screen.dart';
import 'package:movies_app/features/media_details/presentation/screens/movie_details_screen.dart';
import 'package:movies_app/features/media_details/presentation/screens/person_details_screen.dart';
import 'package:movies_app/core/presentation/screens/screen_loader.dart';
import 'package:movies_app/core/presentation/screens/branches_switcher_screen.dart';
import 'package:movies_app/features/media_details/presentation/screens/tv_series_details_screen.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/features/auth/presentation/screens/auth_screen.dart';
import 'package:movies_app/features/home/presentation/screens/home_screen.dart';
import 'package:movies_app/features/search/presentation/screens/search_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.screenLoader,
    errorBuilder: (context, state) => const RouterErrorScreen(),
    routes: [
      GoRoute(
        path: AppRoutes.screenLoader,
        builder: (context, state) => const ScreenLoader(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            BranchesSwitcherScreen(navigationShell: navigationShell),
        branches: [
          patternBranchBuilder(
            parentPath: AppRoutes.home,
            parentScreen: const HomeScreen(),
          ),
          patternBranchBuilder(
            parentPath: AppRoutes.search,
            parentScreen: const SearchScreen(),
          ),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.watchList,
              builder: (context, state) => const WatchListScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.account,
              builder: (context, state) => const AccountScreen(),
            ),
          ]),
        ],
      ),
    ],
  );

  static StatefulShellBranch patternBranchBuilder({
    required String parentPath,
    required Widget parentScreen,
  }) {
    return StatefulShellBranch(routes: [
      GoRoute(
        path: parentPath,
        builder: (context, state) => parentScreen,
        routes: [
          GoRoute(
            path: AppRoutes.movieDetails,
            builder: (context, state) {
              final args = state.extra as List;
              return MovieDetailsScreen(
                movieId: args[0],
                appBarTitle: args[1],
              );
            },
            routes: [
              GoRoute(
                path: AppRoutes.personDetails,
                builder: (context, state) {
                  final args = state.extra as List;
                  return PersonDetailsScreen(
                    personId: args[0],
                    appBarTitle: args[1],
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.tvSeriesDetails,
            builder: (context, state) {
              final args = state.extra as List;
              return TVSeriesDetailsScreen(
                tvSeriesId: args[0],
                appBarTitle: args[1],
              );
            },
            routes: [
              GoRoute(
                path: AppRoutes.personDetails,
                builder: (context, state) {
                  final args = state.extra as List;
                  return PersonDetailsScreen(
                    personId: args[0],
                    appBarTitle: args[1],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ]);
  }

  static GoRouter get router => _router;
}
