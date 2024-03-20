import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/core/presentation/components/dark_poster_gradient.dart';
import 'package:movies_app/core/presentation/components/failure_widget.dart';
import 'package:movies_app/core/presentation/components/media_horizontal_scroll_list.dart';
import 'package:movies_app/core/presentation/components/media_overview_text.dart';
import 'package:movies_app/core/presentation/components/movie_details_head.dart';
import 'package:movies_app/core/presentation/formatters/image_formatter.dart';
import 'package:movies_app/core/presentation/media_details_bloc/media_details_bloc.dart';
import 'package:movies_app/core/routing/app_routes.dart';
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
            return MovieDetailsBody(
              movie: state.mediaModel as MovieModel,
              movieCredits: state.mediaCredits ?? [],
            );
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
    required this.movieCredits,
  });

  final MovieModel movie;
  final List<PersonModel> movieCredits;

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
            const DarkPosterGradient(),
          ],
        ),
        const SizedBox(height: 10),
        MovieDetailsHead(movie: movie),
        const SizedBox(height: 15),
        Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).colorScheme.surface,
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MediaOverviewText(overview: movie.overview),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: MediaHorizontalScrollList(
            models: movieCredits,
          ),
        )
      ],
    );
  }
}
