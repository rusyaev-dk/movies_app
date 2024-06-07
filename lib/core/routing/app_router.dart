import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/presentation/screens/error_screens.dart';
import 'package:movies_app/core/presentation/screens/grid_media_screen.dart';
import 'package:movies_app/features/account/presentation/screens/account_screen.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:movies_app/features/media_details/presentation/screens/unknown_media_screen.dart';
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
                redirect: _authorizationRedirect,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  _movieDetailsRoute,
                  _tvSeriesDetailsRoute,
                  _personDetailsRoute,
                  _gridMediaViewRoute,
                  _unknownMediaRoute,
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                redirect: _authorizationRedirect,
                builder: (context, state) => const SearchScreen(),
                routes: [
                  _movieDetailsRoute,
                  _tvSeriesDetailsRoute,
                  _personDetailsRoute,
                  _unknownMediaRoute,
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.watchlist,
                redirect: _authorizationRedirect,
                builder: (context, state) => const WatchlistScreen(),
                routes: [
                  _movieDetailsRoute,
                  _tvSeriesDetailsRoute,
                  _personDetailsRoute,
                  _unknownMediaRoute,
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.account,
                redirect: _authorizationRedirect,
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
    redirect: _unknownMediaRedirect,
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
    redirect: _unknownMediaRedirect,
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
    redirect: _unknownMediaRedirect,
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
      _unknownMediaRoute,
    ],
  );

  static final GoRoute _unknownMediaRoute = GoRoute(
    path: AppRoutes.unknownMedia,
    builder: (context, state) => const UnknownMediaScreen(),
  );

  static String _getCurrentUriStr() {
    return _router.routeInformationProvider.value.uri.toString();
  }

  static bool _isAuthorized(BuildContext context) {
    final state = context.read<AuthBloc>().state;
    return state is AuthAuthorizedState;
  }

  static String? _authorizationRedirect(
    BuildContext context,
    GoRouterState state,
  ) {
    String? redirect;
    if (!_isAuthorized(context)) {
      redirect = AppRoutes.screenLoader;
    }
    return redirect;
  }

  static String? _unknownMediaRedirect(
    BuildContext context,
    GoRouterState state,
  ) {
    final extra = state.extra as List;

    String? redirect;
    if (extra[0] == null || extra[0] <= 0) {
      final String curUri = _getCurrentUriStr();
      redirect = "$curUri/${AppRoutes.unknownMedia}";
    }
    return redirect;
  }

  static GoRouter get router => _router;
}
