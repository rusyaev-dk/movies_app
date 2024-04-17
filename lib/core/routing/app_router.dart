import 'package:go_router/go_router.dart';
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
    debugLogDiagnostics: true,
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
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  _movieDetailsRoute,
                  _tvSeriesDetailsRoute,
                  _personDetailsRoute,
                  _gridMediaViewRoute,
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (context, state) => const SearchScreen(),
                routes: [
                  _movieDetailsRoute,
                  _tvSeriesDetailsRoute,
                  _personDetailsRoute,
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.watchlist,
                builder: (context, state) => const WatchlistScreen(),
                routes: [
                  _movieDetailsRoute,
                  _tvSeriesDetailsRoute,
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                builder: (context, state) => const AccountScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static final GoRoute _movieDetailsRoute = GoRoute(
    path: "${AppRoutes.movieDetails}/:movie_id",
    builder: (context, state) {
      final extra = state.extra as List;
      return MovieDetailsScreen(
        movieId: extra[0],
        appBarTitle: extra[1],
      );
    },
    routes: [
      _personDetailsRoute,
    ],
  );

  static final GoRoute _tvSeriesDetailsRoute = GoRoute(
    path: "${AppRoutes.tvSeriesDetails}/:tv_series_id",
    builder: (context, state) {
      final extra = state.extra as List;
      return TVSeriesDetailsScreen(
        tvSeriesId: extra[0],
        appBarTitle: extra[1],
      );
    },
    routes: [
      _personDetailsRoute,
    ],
  );

  static final GoRoute _personDetailsRoute = GoRoute(
    path: "${AppRoutes.personDetails}/:person_id",
    builder: (context, state) {
      final extra = state.extra as List;
      return PersonDetailsScreen(
        personId: extra[0],
        appBarTitle: extra[1],
      );
    },
  );

  static final GoRoute _gridMediaViewRoute = GoRoute(
    path: AppRoutes.gridMediaView,
    builder: (context, state) {
      final extra = state.extra as String;
      return GridMediaScreen(
        queryTypeStr: extra,
      );
    },
    routes: [
      _movieDetailsRoute,
      _tvSeriesDetailsRoute,
      _personDetailsRoute,
    ],
  );

  static GoRouter get router => _router;
}
