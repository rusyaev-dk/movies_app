import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/domain/repositories/key_value_storage_repository.dart';
import 'package:movies_app/core/presentation/components/custom_buttons.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/search/domain/models/search_filters_model.dart';
import 'package:movies_app/features/search/domain/repositories/search_filters_repository.dart';
import 'package:movies_app/features/search/presentation/blocs/search_bloc/search_bloc.dart';
import 'package:movies_app/features/search/presentation/blocs/search_filters_bloc/search_filters_bloc.dart';
import 'package:movies_app/features/search/presentation/components/filters_bottom_sheet/bottom_sheet_components.dart';

class FiltersBottomSheet extends StatelessWidget {
  const FiltersBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchFiltersBloc(
        keyValueStorageRepository:
            RepositoryProvider.of<KeyValueStorageRepository>(context),
        searchFiltersRepository:
            RepositoryProvider.of<SearchFiltersRepository>(context),
        searchBloc: RepositoryProvider.of<SearchBloc>(context),
      ),
      child: const FiltersBottomSheetContent(),
    );
  }
}

class FiltersBottomSheetContent extends StatelessWidget {
  const FiltersBottomSheetContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchFiltersBloc, SearchFiltersState>(
      builder: (context, state) {
        if (state is SearchFiltersFailureState) {
          return Center(
            child: Text(
              "Oops, something went wrong...",
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .headingTextStyle,
            ),
          );
        } else if (state is SearchFiltersLoadedState) {
          return Padding(
            padding:
                const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 4,
                    width: 55,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .extension<ThemeColors>()!
                          .activatedFilterButtonColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MediaTypeFilterSection(filtersModel: state.searchFiltersModel),
                const SizedBox(height: 10),
                SortByFilterSection(filtersModel: state.searchFiltersModel),
                const SizedBox(height: 10),
                AnimatedOpacity(
                  opacity: state.searchFiltersModel.showMediaTypeFilter !=
                          ShowMediaTypeFilter.persons
                      ? 1
                      : 0,
                  duration: const Duration(milliseconds: 250),
                  child: RatingFilterSection(
                      filtersModel: state.searchFiltersModel),
                ),
                const Spacer(),
                const BottomButtonsSection(),
              ],
            ),
          );
        } else {
          return const RepaintBoundary(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

class MediaTypeFilterSection extends StatelessWidget {
  const MediaTypeFilterSection({
    super.key,
    required this.filtersModel,
  });

  final SearchFiltersModel filtersModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Show",
          style:
              Theme.of(context).extension<ThemeTextStyles>()!.headingTextStyle,
        ),
        const SizedBox(height: 8),
        MediaTypeFilterRow(filtersModel: filtersModel),
      ],
    );
  }
}

class SortByFilterSection extends StatelessWidget {
  const SortByFilterSection({
    super.key,
    required this.filtersModel,
  });

  final SearchFiltersModel filtersModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Sort by",
          style:
              Theme.of(context).extension<ThemeTextStyles>()!.headingTextStyle,
        ),
        const SizedBox(height: 8),
        SortByFilterRow(filtersModel: filtersModel),
      ],
    );
  }
}

class RatingFilterSection extends StatelessWidget {
  const RatingFilterSection({
    super.key,
    required this.filtersModel,
  });

  final SearchFiltersModel filtersModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Rating",
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .headingTextStyle,
            ),
            Text(
              "from ${filtersModel.ratingFilter}",
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .subtitleTextStyle
                  .copyWith(
                    fontSize: 17,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        RatingSlider(filtersModel: filtersModel),
      ],
    );
  }
}

class BottomButtonsSection extends StatelessWidget {
  const BottomButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: CustomGradientButton(
            text: "Apply filters",
            width: double.infinity,
            onPressed: () {
              context.pop();
              context
                  .read<SearchFiltersBloc>()
                  .add(SearchFiltersApplyFiltersEvent());
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 45,
            child: TextButton(
              style: TextButton.styleFrom(
                overlayColor: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () => context
                  .read<SearchFiltersBloc>()
                  .add(SearchFiltersResetFiltersEvent()),
              child: Text(
                "Reset",
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .headingTextStyle
                    .copyWith(fontSize: 17),
              ),
            ),
          ),
        )
      ],
    );
  }
}
