import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/features/media_details/presentation/blocs/tv_series_details_bloc/tv_series_details_bloc.dart';
import 'package:movies_app/features/media_details/presentation/components/dark_poster_gradient.dart';
import 'package:movies_app/core/presentation/components/media/media_horizontal_list_view.dart';
import 'package:movies_app/features/media_details/presentation/components/media_details_buttons.dart';
import 'package:movies_app/features/media_details/presentation/components/media_details_rating.dart';
import 'package:movies_app/features/media_details/presentation/components/media_overview_text.dart';
import 'package:movies_app/features/media_details/presentation/components/tv_series/tv_series_details_failure_widget.dart';
import 'package:movies_app/features/media_details/presentation/components/tv_series/tv_series_details_head.dart';
import 'package:movies_app/core/presentation/formatters/image_formatter.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/media_details/presentation/cubits/media_details_appbar_cubit/media_details_appbar_cubit.dart';
import 'package:shimmer/shimmer.dart';

class TVSeriesDetailsBody extends StatelessWidget {
  const TVSeriesDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TVSeriesDetailsBloc, TVSeriesDetailsState>(
      builder: (context, state) {
        if (state.failure != null) {
          return TvSeriesDetailsFailureWidget(
            failure: state.failure!,
            tvSeriesId: state.tvSeriesId,
          );
        } else if (!state.isLoading && state.tvSeriesModel != null) {
          return TVSeriesDetailsContent(
            tvSeries: state.tvSeriesModel!,
            tvSeriesImages: state.tvSeriesImages ?? [],
            tvSeriesCredits: state.tvSeriesCredits ?? [],
            similarTVSeries: state.similarTVSeries ?? [],
          );
        } else {
          return TVSeriesDetailsContent.shimmerLoading(context);
        }
      },
    );
  }
}

class TVSeriesDetailsContent extends StatefulWidget {
  const TVSeriesDetailsContent({
    super.key,
    required this.tvSeries,
    required this.tvSeriesImages,
    required this.tvSeriesCredits,
    required this.similarTVSeries,
  });

  final TVSeriesModel tvSeries;
  final List<MediaImageModel> tvSeriesImages;
  final List<PersonModel> tvSeriesCredits;
  final List<TVSeriesModel> similarTVSeries;

  static Widget shimmerLoading(BuildContext context) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: Theme.of(context).extension<ThemeGradients>()!.shimmerGradient,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            height: 600,
            width: double.infinity,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          TVSeriesDetailsHead.shimmerLoading(),
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
  State<TVSeriesDetailsContent> createState() => _TVSeriesDetailsContentState();
}

class _TVSeriesDetailsContentState extends State<TVSeriesDetailsContent> {
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
    Widget imageWidget = ApiImageFormatter.formatImageWidget(context,
        imagePath: widget.tvSeries.posterPath, width: 100);

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
            const DarkPosterGradient(),
          ],
        ),
        const SizedBox(height: 10),
        TVSeriesDetailsHead(tvSeries: widget.tvSeries),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: BlocBuilder<TVSeriesDetailsBloc, TVSeriesDetailsState>(
            buildWhen: (previous, current) =>
                previous.isFavourite != current.isFavourite ||
                previous.isInWatchlist != current.isInWatchlist,
            builder: (context, state) {
              return MediaDetailsButtons(
                isFavourite: state.isFavourite!,
                isInWatchlist: state.isInWatchlist!,
                favouriteBtnOnPressed: () {
                  context
                      .read<TVSeriesDetailsBloc>()
                      .add(TVSeriesDetailsAddToFavouriteEvent(
                        tvSeriesId: state.tvSeriesModel!.id!,
                        isFavorite: state.isFavourite!,
                      ));
                },
                watchListBtnOnPressed: () {
                  context
                      .read<TVSeriesDetailsBloc>()
                      .add(TVSeriesDetailsAddToWatchlistEvent(
                        tvSeriesId: state.tvSeriesModel!.id!,
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
        if (widget.tvSeries.overview != null &&
            widget.tvSeries.overview!.trim().isNotEmpty)
          const SizedBox(height: 15),
        if (widget.tvSeries.overview != null &&
            widget.tvSeries.overview!.trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MediaOverviewText(overview: widget.tvSeries.overview!),
          ),
        if (widget.tvSeriesImages.isNotEmpty) const SizedBox(height: 20),
        if (widget.tvSeriesImages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: MediaHorizontalListView(
              title: "Images",
              withAllButton: false,
              models: widget.tvSeriesImages,
            ),
          ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MediaDetailsRating(
            voteAverage: widget.tvSeries.voteAverage ?? 0,
            voteCount: widget.tvSeries.voteCount ?? 0,
          ),
        ),
        if (widget.tvSeriesCredits.isNotEmpty) const SizedBox(height: 20),
        if (widget.tvSeriesCredits.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: MediaHorizontalListView(
              title: "Credits",
              withAllButton: false,
              models: widget.tvSeriesCredits,
            ),
          ),
        if (widget.similarTVSeries.isNotEmpty) const SizedBox(height: 20),
        if (widget.similarTVSeries.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: MediaHorizontalListView(
              title: "Similar TV series",
              withAllButton: false,
              models: widget.similarTVSeries,
            ),
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
