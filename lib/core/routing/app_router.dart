import 'package:go_router/go_router.dart';
import 'package:movies_app/core/presentation/screens/error_screens.dart';
import 'package:movies_app/core/presentation/screens/movie_details_screen.dart';
import 'package:movies_app/core/presentation/screens/person_details_screen.dart';
import 'package:movies_app/core/presentation/screens/screen_loader.dart';
import 'package:movies_app/core/presentation/screens/branches_switcher_screen.dart';
import 'package:movies_app/core/presentation/screens/tv_series_details_screen.dart';
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
          StatefulShellBranch(routes: [
            GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                      path: "movie_details",
                      builder: ((context, state) {
                        final args = state.extra as List;
                        return MovieDetailsScreen(
                          movieId: args[0],
                          appBarTitle: args[1],
                        );
                      }),
                      routes: [
                        GoRoute(
                          path: "person_details",
                          builder: (context, state) {
                            final args = state.extra as List;
                            return PersonDetailsScreen(
                              personId: args[0],
                              appBarTitle: args[1],
                            );
                          },
                        )
                      ]),
                  GoRoute(
                      path: "tv_series_details",
                      builder: ((context, state) {
                        final args = state.extra as List;
                        return TVSeriesDetailsScreen(
                          tvSeriesId: args[0],
                          appBarTitle: args[1],
                        );
                      }),
                      routes: [
                        GoRoute(
                          path: "person_details",
                          builder: (context, state) {
                            final args = state.extra as List;
                            return PersonDetailsScreen(
                              personId: args[0],
                              appBarTitle: args[1],
                            );
                          },
                        ),
                      ]),
                ]),
          ]),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (context, state) => const SearchScreen(),
                routes: [
                  GoRoute(
                      path: "movie_details",
                      builder: ((context, state) {
                        final args = state.extra as List;
                        return MovieDetailsScreen(
                          movieId: args[0],
                          appBarTitle: args[1],
                        );
                      }),
                      routes: [
                        GoRoute(
                          path: "person_details",
                          builder: (context, state) {
                            final args = state.extra as List;
                            return PersonDetailsScreen(
                              personId: args[0],
                              appBarTitle: args[1],
                            );
                          },
                        )
                      ]),
                  GoRoute(
                      path: "tv_series_details",
                      builder: ((context, state) {
                        final args = state.extra as List;
                        return TVSeriesDetailsScreen(
                          tvSeriesId: args[0],
                          appBarTitle: args[1],
                        );
                      }),
                      routes: [
                        GoRoute(
                          path: "person_details",
                          builder: (context, state) {
                            final args = state.extra as List;
                            return PersonDetailsScreen(
                              personId: args[0],
                              appBarTitle: args[1],
                            );
                          },
                        ),
                      ]),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );

  static GoRouter get router => _router;
}
