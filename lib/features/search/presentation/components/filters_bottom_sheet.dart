import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/key_value_storage_repository.dart';
import 'package:movies_app/core/presentation/components/custom_buttons.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/search/domain/models/search_filters_model.dart';
import 'package:movies_app/features/search/domain/repositories/search_filters_repository.dart';
import 'package:movies_app/features/search/presentation/blocs/search_filters_bloc/search_filters_bloc.dart';

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
      ),
      child: SizedBox(
        height: 600,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Show",
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .headingTextStyle,
              ),
              const SizedBox(height: 8),
              const MediaTypesFilterRow(),
              const SizedBox(height: 12),
              Text(
                "Sort by",
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .headingTextStyle,
              ),
              const SizedBox(height: 8),
              const SortByFiltersRow(),
            ],
          ),
        ),
      ),
    );
  }
}

class MediaTypesFilterRow extends StatelessWidget {
  const MediaTypesFilterRow({super.key});

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
        }

        if (state is SearchFiltersLoadedState) {
          return Row(
            children: [
              Expanded(
                child: CustomFilterButton(
                  color: state.searchFiltersModel.showMediaTypeFilter ==
                          ShowMediaTypeFilter.all
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context)
                          .extension<ThemeColors>()!
                          .surfaceDarker,
                  onPressed: () {
                    context.read<SearchFiltersBloc>().add(
                          SearchFiltersSetShowMediaTypeEvent(
                            showMediaTypeFilter: ShowMediaTypeFilter.all,
                            prevFiltersModel: state.searchFiltersModel,
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
                  color: state.searchFiltersModel.showMediaTypeFilter ==
                          ShowMediaTypeFilter.movies
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context)
                          .extension<ThemeColors>()!
                          .surfaceDarker,
                  onPressed: () {
                    context.read<SearchFiltersBloc>().add(
                          SearchFiltersSetShowMediaTypeEvent(
                            showMediaTypeFilter: ShowMediaTypeFilter.movies,
                            prevFiltersModel: state.searchFiltersModel,
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
                  color: state.searchFiltersModel.showMediaTypeFilter ==
                          ShowMediaTypeFilter.tvs
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context)
                          .extension<ThemeColors>()!
                          .surfaceDarker,
                  onPressed: () {
                    context.read<SearchFiltersBloc>().add(
                          SearchFiltersSetShowMediaTypeEvent(
                            showMediaTypeFilter: ShowMediaTypeFilter.tvs,
                            prevFiltersModel: state.searchFiltersModel,
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
                  color: state.searchFiltersModel.showMediaTypeFilter ==
                          ShowMediaTypeFilter.persons
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context)
                          .extension<ThemeColors>()!
                          .surfaceDarker,
                  onPressed: () {
                    context.read<SearchFiltersBloc>().add(
                          SearchFiltersSetShowMediaTypeEvent(
                            showMediaTypeFilter: ShowMediaTypeFilter.persons,
                            prevFiltersModel: state.searchFiltersModel,
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class SortByFiltersRow extends StatelessWidget {
  const SortByFiltersRow({super.key});

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
        }

        if (state is SearchFiltersLoadedState) {
          return Row(
            children: [
              Expanded(
                child: CustomFilterButton(
                  color: state.searchFiltersModel.sortByFilter ==
                          SortByFilter.rating
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context)
                          .extension<ThemeColors>()!
                          .surfaceDarker,
                  onPressed: () {
                    context.read<SearchFiltersBloc>().add(
                          SearchFiltersSetSortByEvent(
                            sortByFilter: SortByFilter.rating,
                            prevFiltersModel: state.searchFiltersModel,
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
                  color: state.searchFiltersModel.sortByFilter ==
                          SortByFilter.popularity
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context)
                          .extension<ThemeColors>()!
                          .surfaceDarker,
                  onPressed: () {
                    context.read<SearchFiltersBloc>().add(
                          SearchFiltersSetSortByEvent(
                            sortByFilter: SortByFilter.popularity,
                            prevFiltersModel: state.searchFiltersModel,
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
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
