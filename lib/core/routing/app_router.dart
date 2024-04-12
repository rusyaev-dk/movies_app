import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/presentation/screens/error_screens.dart';
import 'package:movies_app/core/presentation/screens/grid_media_screen.dart';
import 'package:movies_app/features/account/presentation/screens/account_screen.dart';
import 'package:movies_app/features/watchlist/presentation/screens/watchlist_screen.dart';
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
    // debugLogDiagnostics: true,
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
          homeBranchBuilder(),
          searchBranchBuilder(),
          StatefulShellBranch(routes: [
            GoRoute(
              path: AppRoutes.watchlist,
              builder: (context, state) => const WatchlistScreen(),
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

  static StatefulShellBranch searchBranchBuilder() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.search,
          builder: (context, state) => const SearchScreen(),
          routes: [
            GoRoute(
              path: AppRoutes.movieDetails,
              builder: (context, state) {
                final args = state.extra as List;
                return MovieDetailsScreen(
                  key: ValueKey(args),
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
    );
  }

  static StatefulShellBranch homeBranchBuilder() {
    return StatefulShellBranch(
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
          routes: [
            GoRoute(
              path: AppRoutes.movieDetails,
              builder: (context, state) {
                final args = state.extra as List;
                return MovieDetailsScreen(
                  key: ValueKey(args),
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
            GoRoute(
              path: AppRoutes.allMediaView,
              builder: (context, state) {
                final args = state.extra as ApiMediaQueryType;
                return GridMediaScreen(
                  queryType: args,
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  static GoRouter get router => _router;
}
