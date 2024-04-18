import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/features/media_details/presentation/blocs/movie_details_bloc/movie_details_bloc.dart';
import 'package:movies_app/features/media_details/presentation/components/dark_poster_gradient.dart';
import 'package:movies_app/core/presentation/components/media/media_horizontal_list_view.dart';
import 'package:movies_app/features/media_details/presentation/components/media_details_buttons.dart';
import 'package:movies_app/features/media_details/presentation/components/media_details_rating.dart';
import 'package:movies_app/features/media_details/presentation/components/media_overview_text.dart';
import 'package:movies_app/features/media_details/presentation/components/movie/movie_details_failure_widget.dart';
import 'package:movies_app/features/media_details/presentation/components/movie/movie_details_head.dart';
import 'package:movies_app/core/presentation/formatters/image_formatter.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/media_details/presentation/components/movie_details_budget.dart';
import 'package:movies_app/features/media_details/presentation/cubits/media_details_appbar_cubit/media_details_appbar_cubit.dart';
import 'package:shimmer/shimmer.dart';

class MovieDetailsBody extends StatelessWidget {
  const MovieDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      builder: (context, state) {
        if (state.failure != null) {
          return MovieDetailsFailureWidget(
            failure: state.failure!,
            movieId: state.movieId,
          );
        } else if (!state.isLoading && state.movieModel != null) {
          return MovieDetailsContent(
            movie: state.movieModel!,
            movieImages: state.movieImages ?? [],
            movieCredits: state.movieCredits ?? [],
            similarMovies: state.similarMovies ?? [],
          );
        } else {
          return MovieDetailsContent.shimmerLoading(context);
        }
      },
    );
  }
}

class MovieDetailsContent extends StatefulWidget {
  const MovieDetailsContent({
    super.key,
    required this.movie,
    required this.movieImages,
    required this.movieCredits,
    required this.similarMovies,
  });

  final MovieModel movie;
  final List<MediaImageModel> movieImages;
  final List<PersonModel> movieCredits;
  final List<MovieModel> similarMovies;

  static Widget shimmerLoading(BuildContext context) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: Theme.of(context).extension<ThemeGradients>()!.shimmerGradient,
      child: ListView(
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            height: 600,
            width: double.infinity,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          MovieDetailsHead.shimmerLoading(),
          const SizedBox(height: 15),
          Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.surface,
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MediaOverviewText.shimmerLoading(),
          ),
        ],
      ),
    );
  }

  @override
  State<MovieDetailsContent> createState() => _MovieDetailsContentState();
}

class _MovieDetailsContentState extends State<MovieDetailsContent> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final currentState = context.read<MediaDetailsAppbarCubit>().state;

    if (_scrollController.position.pixels > 600 &&
        currentState == MediaDetailsAppbarState.transparent) {
      context.read<MediaDetailsAppbarCubit>().fillAppBar();
    } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        _scrollController.position.pixels < 600 &&
        currentState == MediaDetailsAppbarState.filled) {
      context.read<MediaDetailsAppbarCubit>().unFillAppBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = ApiImageFormatter.formatImageWidget(
      context,
      imagePath: widget.movie.posterPath,
      width: 100,
      height: 600,
    );

    return ListView(
      controller: _scrollController,
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
            if (widget.movie.posterPath != null) const DarkPosterGradient(),
          ],
        ),
        const SizedBox(height: 10),
        MovieDetailsHead(movie: widget.movie),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
            buildWhen: (previous, current) =>
                previous.isFavourite != current.isFavourite ||
                previous.isInWatchlist != current.isInWatchlist,
            builder: (context, state) {
              return MediaDetailsButtons(
                isFavourite: state.isFavourite!,
                isInWatchlist: state.isInWatchlist!,
                favouriteBtnOnPressed: () {
                  context
                      .read<MovieDetailsBloc>()
                      .add(MovieDetailsAddToFavouriteEvent(
                        movieId: state.movieModel!.id!,
                        isFavorite: state.isFavourite!,
                      ));
                },
                watchListBtnOnPressed: () {
                  context
                      .read<MovieDetailsBloc>()
                      .add(MovieDetailsAddToWatchlistEvent(
                        movieId: state.movieModel!.id!,
                        isInWatchlist: state.isInWatchlist!,
                      ));
                },
                shareBtnOnPressed: () {},
              );
            },
          ),
        ),
        const SizedBox(height: 15),
        Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).colorScheme.surface,
        ),
        if (widget.movie.overview != null &&
            widget.movie.overview!.trim().isNotEmpty)
          const SizedBox(height: 15),
        if (widget.movie.overview != null &&
            widget.movie.overview!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MediaOverviewText(overview: widget.movie.overview!),
          ),
        if (widget.movieImages.isNotEmpty) const SizedBox(height: 20),
        if (widget.movieImages.isNotEmpty)
          MediaHorizontalListView(
            title: "Images",
            withAllButton: false,
            models: widget.movieImages,
          ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MediaDetailsRating(
            voteAverage: widget.movie.voteAverage ?? 0,
            voteCount: widget.movie.voteCount ?? 0,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MediaDetailsBudget(
            budget: widget.movie.budget ?? 0,
            revenue: widget.movie.revenue ?? 0,
          ),
        ),
        if (widget.movieCredits.isNotEmpty) const SizedBox(height: 20),
        if (widget.movieCredits.isNotEmpty)
          MediaHorizontalListView(
            title: "Credits",
            withAllButton: false,
            models: widget.movieCredits,
          ),
        if (widget.similarMovies.isNotEmpty) const SizedBox(height: 20),
        if (widget.similarMovies.isNotEmpty)
          MediaHorizontalListView(
            title: "Similar movies",
            withAllButton: false,
            models: widget.similarMovies,
          ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }
}
