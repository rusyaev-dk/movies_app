import 'package:go_router/go_router.dart';
import 'package:movies_app/core/presentation/screens/error_screens.dart';
import 'package:movies_app/core/presentation/screens/screen_loader.dart';
import 'package:movies_app/core/presentation/screens/branches_switcher_screen.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/features/auth/presentation/screens/auth_screen.dart';
import 'package:movies_app/features/home/presentation/screens/home_screen.dart';
import 'package:movies_app/core/presentation/screens/media_details_switcher_screen.dart';
import 'package:movies_app/features/search/presentation/screens/search_screen.dart';

class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: AppRoutes.screenLoader, // изменить
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
                    GoRoute(
                      path: "mediaDetails",
                      builder: ((context, state) {
                        final args = state.extra as List;
                        return MediaDetailsSwitcherScreen(
                          mediaType: args[0],
                          appBarTitle: args[1],
                          mediaId: args[2],
                        );
                      }),
                    ),
                  ]),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (context, state) => const SearchScreen(),
              )
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const RouterErrorScreen(),
  );

  // static void goTo(String route) {
  //   _router.go(route);
  // }

  static GoRouter get router => _router;
}
