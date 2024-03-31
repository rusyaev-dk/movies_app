import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/features/media_details/presentation/blocs/tv_series_details_bloc/tv_series_details_bloc.dart';
import 'package:movies_app/core/presentation/components/dark_poster_gradient.dart';
import 'package:movies_app/core/presentation/components/failure_widget.dart';
import 'package:movies_app/core/presentation/components/media/media_horizontal_list_view.dart';
import 'package:movies_app/features/media_details/presentation/components/media_details_buttons.dart';
import 'package:movies_app/features/media_details/presentation/components/media_details_rating.dart';
import 'package:movies_app/features/media_details/presentation/components/media_overview_text.dart';
import 'package:movies_app/features/media_details/presentation/components/tv_series/tv_series_details_head.dart';
import 'package:movies_app/core/presentation/formatters/image_formatter.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:movies_app/features/media_details/presentation/cubits/media_details_appbar_cubit/media_details_appbar_cubit.dart';
import 'package:shimmer/shimmer.dart';

class TVSeriesDetailsBody extends StatelessWidget {
  const TVSeriesDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TvSeriesDetailsBloc, TVSeriesDetailsState>(
      builder: (context, state) {
        if (state is TVSeriesDetailsFailureState) {
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
                      .read<TvSeriesDetailsBloc>()
                      .add(TVSeriesDetailsLoadDetailsEvent(
                        tvSeriesId: state.tvSeriesId!,
                      ));
                },
              );
            default:
              return FailureWidget(failure: state.failure);
          }
        }
        if (state is TVSeriesDetailsLoadingState) {
          return TVSeriesDetailsContent.shimmerLoading(context);
        }

        if (state is TVSeriesDetailsLoadedState) {
          return TVSeriesDetailsContent(
            tvSeries: state.tvSeriesModel,
            tvSeriesImages: state.tvSeriesImages ?? [],
            tvSeriesCredits: state.tvSeriesCredits ?? [],
            similarTVSeries: state.similarTVSeries ?? [],
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class TVSeriesDetailsContent extends StatelessWidget {
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
        padding: const EdgeInsets.all(0),
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
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      final currentState = context.read<MediaDetailsAppbarCubit>().state;

      if (scrollController.position.pixels > 600 &&
          currentState == MediaDetailsAppbarState.transparent) {
        context.read<MediaDetailsAppbarCubit>().fillAppBar();
      } else if (scrollController.position.userScrollDirection ==
              ScrollDirection.forward &&
          scrollController.position.pixels < 600 &&
          currentState == MediaDetailsAppbarState.filled) {
        context.read<MediaDetailsAppbarCubit>().unFillAppBar();
      }
    });

    Widget imageWidget = ApiImageFormatter.formatImageWidget(context,
        imagePath: tvSeries.posterPath, width: 100);

    return ListView(
      controller: scrollController,
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
        TVSeriesDetailsHead(tvSeries: tvSeries),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MediaDetailsButtons(
            favouriteBtnOnPressed: () {},
            watchListBtnOnPressed: () {},
            shareBtnOnPressed: () {},
          ),
        ),
        const SizedBox(height: 15),
        Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).colorScheme.surface,
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MediaOverviewText(overview: tvSeries.overview),
        ),
        if (tvSeriesImages.isNotEmpty) const SizedBox(height: 15),
        if (tvSeriesImages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: MediaHorizontalListView(
              title: "Images",
              withAllButton: false,
              models: tvSeriesImages,
            ),
          ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MediaDetailsRating(
            voteAverage: tvSeries.voteAverage ?? 0,
            voteCount: tvSeries.voteCount ?? 0,
          ),
        ),
        if (tvSeriesCredits.isNotEmpty) const SizedBox(height: 10),
        if (tvSeriesCredits.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: MediaHorizontalListView(
              title: "Credits",
              withAllButton: false,
              models: tvSeriesCredits,
            ),
          ),
        if (similarTVSeries.isNotEmpty) const SizedBox(height: 10),
        if (similarTVSeries.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: MediaHorizontalListView(
              title: "Similar TV Series",
              withAllButton: false,
              models: similarTVSeries,
            ),
          ),
      ],
    );
  }
}
