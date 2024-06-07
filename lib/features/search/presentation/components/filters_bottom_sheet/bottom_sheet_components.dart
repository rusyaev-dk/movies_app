import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/presentation/components/custom_buttons.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/search/domain/models/search_filters_model.dart';
import 'package:movies_app/features/search/presentation/blocs/search_filters_bloc/search_filters_bloc.dart';

class MediaTypeFilterRow extends StatelessWidget {
  const MediaTypeFilterRow({
    super.key,
    required this.filtersModel,
  });

  final SearchFiltersModel filtersModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomFilterButton(
            color: filtersModel.showMediaTypeFilter == ShowMediaTypeFilter.all
                ? Theme.of(context)
                    .extension<ThemeColors>()!
                    .activatedFilterButtonColor
                : Theme.of(context).extension<ThemeColors>()!.inActivatedFilterButtonColor,
            onPressed: () {
              context.read<SearchFiltersBloc>().add(
                    SearchFiltersSetShowMediaTypeFilterEvent(
                      showMediaTypeFilter: ShowMediaTypeFilter.all,
                      prevFiltersModel: filtersModel,
                    ),
                  );
            },
            text: "All",
            borderRadiusDirection: BorderRadiusDirection.left,
          ),
        ),
        Divider(
          height: 55,
          thickness: 1,
          color: Theme.of(context).colorScheme.secondary,
        ),
        Expanded(
          child: CustomFilterButton(
            color:
                filtersModel.showMediaTypeFilter == ShowMediaTypeFilter.movies
                    ? Theme.of(context)
                        .extension<ThemeColors>()!
                        .activatedFilterButtonColor
                    : Theme.of(context).extension<ThemeColors>()!.inActivatedFilterButtonColor,
            onPressed: () {
              context.read<SearchFiltersBloc>().add(
                    SearchFiltersSetShowMediaTypeFilterEvent(
                      showMediaTypeFilter: ShowMediaTypeFilter.movies,
                      prevFiltersModel: filtersModel,
                    ),
                  );
            },
            text: "Movies",
            borderRadiusDirection: BorderRadiusDirection.none,
          ),
        ),
        Divider(
          height: 55,
          thickness: 1,
          color: Theme.of(context).colorScheme.secondary,
        ),
        Expanded(
          child: CustomFilterButton(
            color: filtersModel.showMediaTypeFilter == ShowMediaTypeFilter.tvs
                ? Theme.of(context)
                    .extension<ThemeColors>()!
                    .activatedFilterButtonColor
                : Theme.of(context).extension<ThemeColors>()!.inActivatedFilterButtonColor,
            onPressed: () {
              context.read<SearchFiltersBloc>().add(
                    SearchFiltersSetShowMediaTypeFilterEvent(
                      showMediaTypeFilter: ShowMediaTypeFilter.tvs,
                      prevFiltersModel: filtersModel,
                    ),
                  );
            },
            text: "TV series",
            borderRadiusDirection: BorderRadiusDirection.none,
          ),
        ),
        Divider(
          height: 55,
          thickness: 1,
          color: Theme.of(context).colorScheme.secondary,
        ),
        Expanded(
          child: CustomFilterButton(
            color:
                filtersModel.showMediaTypeFilter == ShowMediaTypeFilter.persons
                    ? Theme.of(context)
                        .extension<ThemeColors>()!
                        .activatedFilterButtonColor
                    : Theme.of(context).extension<ThemeColors>()!.inActivatedFilterButtonColor,
            onPressed: () {
              context.read<SearchFiltersBloc>().add(
                    SearchFiltersSetShowMediaTypeFilterEvent(
                      showMediaTypeFilter: ShowMediaTypeFilter.persons,
                      prevFiltersModel: filtersModel,
                    ),
                  );
            },
            text: "Persons",
            borderRadiusDirection: BorderRadiusDirection.right,
          ),
        ),
      ],
    );
  }
}

class SortByFilterRow extends StatelessWidget {
  const SortByFilterRow({
    super.key,
    required this.filtersModel,
  });

  final SearchFiltersModel filtersModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomFilterButton(
            color: filtersModel.sortByFilter == SortByFilter.rating
                ? Theme.of(context)
                    .extension<ThemeColors>()!
                    .activatedFilterButtonColor
                : Theme.of(context).extension<ThemeColors>()!.inActivatedFilterButtonColor,
            onPressed: () {
              context.read<SearchFiltersBloc>().add(
                    SearchFiltersSetSortByFilterEvent(
                      sortByFilter: SortByFilter.rating,
                      prevFiltersModel: filtersModel,
                    ),
                  );
            },
            text: "Rating",
            borderRadiusDirection: BorderRadiusDirection.left,
          ),
        ),
        Divider(
          height: 55,
          thickness: 1,
          color: Theme.of(context).colorScheme.secondary,
        ),
        Expanded(
          child: CustomFilterButton(
            color: filtersModel.sortByFilter == SortByFilter.popularity
                ? Theme.of(context)
                    .extension<ThemeColors>()!
                    .activatedFilterButtonColor
                : Theme.of(context).extension<ThemeColors>()!.inActivatedFilterButtonColor,
            onPressed: () {
              context.read<SearchFiltersBloc>().add(
                    SearchFiltersSetSortByFilterEvent(
                      sortByFilter: SortByFilter.popularity,
                      prevFiltersModel: filtersModel,
                    ),
                  );
            },
            text: "Popularity",
            borderRadiusDirection: BorderRadiusDirection.right,
          ),
        ),
      ],
    );
  }
}

class RatingSlider extends StatelessWidget {
  const RatingSlider({
    super.key,
    required this.filtersModel,
  });

  final SearchFiltersModel filtersModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).extension<ThemeColors>()!.inActivatedFilterButtonColor,
      ),
      child: Slider(
        value: filtersModel.ratingFilter.toDouble(),
        min: 0,
        max: 10,
        onChanged: (newRatingFilter) {
          context.read<SearchFiltersBloc>().add(
                SearchFiltersSetRatingFilterEvent(
                  ratingFilter: newRatingFilter.toInt(),
                  prevFiltersModel: filtersModel,
                ),
              );
        },
      ),
    );
  }
}
