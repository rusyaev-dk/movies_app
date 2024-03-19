import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/components/failure_widget.dart';
import 'package:movies_app/core/presentation/image_formatter.dart';
import 'package:movies_app/core/presentation/media_details_bloc/media_details_bloc.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({
    super.key,
    required this.appBarTitle,
  });

  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.star_border))
        ],
      ),
      body: BlocBuilder<MediaDetailsBloc, MediaDetailsState>(
        builder: (context, state) {
          if (state is MediaDetailsFailureState) {
            switch (state.failure.type) {
              case (ApiClientExceptionType.sessionExpired):
                return FailureWidget(
                    failure: state.failure,
                    buttonText: "Login",
                    icon: Icons.exit_to_app_outlined,
                    onPressed: () {
                      context.read<AuthBloc>().add(AuthLogoutEvent());
                      context.go(AppRoutes.screenLoader);
                    });
              case (ApiClientExceptionType.network):
                return FailureWidget(
                  failure: state.failure,
                  buttonText: "Update",
                  icon: Icons.wifi_off,
                  onPressed: () {
                    context
                        .read<MediaDetailsBloc>()
                        .add(MediaDetailsLoadDetailsEvent(
                          mediaType: TMDBMediaType.movie,
                          mediaId: state.mediaId!,
                        ));
                  },
                );
              default:
                return FailureWidget(failure: state.failure);
            }
          }
          if (state is MediaDetailsLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is MediaDetailsLoadedState) {
            return MovieDetailsBody(movie: state.mediaModel as MovieModel);
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class MovieDetailsBody extends StatelessWidget {
  const MovieDetailsBody({
    super.key,
    required this.movie,
  });

  final MovieModel movie;

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = ApiImageFormatter.formatImageWidget(context,
        imagePath: movie.posterPath);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Stack(
          alignment: Alignment.topLeft,
          children: [
            SizedBox(
              height: 600,
              width: double.infinity,
              child: imageWidget,
            ),
            Container(
              height: 600,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.4),
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                color: Colors.black,
                child: Text(
                  movie.title ?? "Unknown movie",
                  style: Theme.of(context)
                      .extension<ThemeTextStyles>()!
                      .headingTextStyle,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
