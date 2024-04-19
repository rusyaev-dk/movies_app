import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/features/media_details/presentation/blocs/person_details_bloc/person_details_bloc.dart';
import 'package:movies_app/features/media_details/presentation/components/person/person_details_failure_widget.dart';
import 'package:movies_app/features/media_details/presentation/components/person/person_info_text.dart';
import 'package:movies_app/core/presentation/formatters/image_formatter.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/media_details/presentation/cubits/media_details_appbar_cubit/media_details_appbar_cubit.dart';
import 'package:shimmer/shimmer.dart';

class PersonDetailsBody extends StatelessWidget {
  const PersonDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonDetailsBloc, PersonDetailsState>(
      builder: (context, state) {
        if (state is PersonDetailsFailureState) {
          return PersonDetailsFailureWidget(
            failure: state.failure,
            personId: state.personId,
          );
        } else if (state is PersonDetailsLoadedState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: PersonDetailsContent(person: state.personModel),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: PersonDetailsContent.shimmerLoading(context),
          );
        }
      },
    );
  }
}

class PersonDetailsContent extends StatefulWidget {
  const PersonDetailsContent({
    super.key,
    required this.person,
  });

  final PersonModel person;

  static Widget shimmerLoading(BuildContext context) {
    return Shimmer(
      direction: ShimmerDirection.ltr,
      gradient: Theme.of(context).extension<ThemeGradients>()!.shimmerGradient,
      child: ListView(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 210,
                width: 140,
                color: Colors.white,
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 18,
                      width: 80,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 15,
                      width: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 15,
                      width: 50,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 15,
                      width: 50,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              Container(
                height: 20,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                height: 20,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                height: 20,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                height: 20,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
            ],
          )
        ],
      ),
    );
  }

  @override
  State<PersonDetailsContent> createState() => _PersonDetailsContentState();
}

class _PersonDetailsContentState extends State<PersonDetailsContent> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final currentState = context.read<MediaDetailsAppbarCubit>().state;

    if (_scrollController.position.pixels > 33 &&
        currentState == MediaDetailsAppbarState.transparent) {
      context.read<MediaDetailsAppbarCubit>().fillAppBar();
    } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        _scrollController.position.pixels < 33 &&
        currentState == MediaDetailsAppbarState.filled) {
      context.read<MediaDetailsAppbarCubit>().unFillAppBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = ApiImageFormatter.formatImageWidget(context,
        imagePath: widget.person.profilePath, width: 100);

    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.zero,
      itemCount: 1,
      itemBuilder: (context, _) {
        return Animate(
          effects: const [FadeEffect()],
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 210,
                    width: 140,
                    child: imageWidget,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: PersonInfoText(
                      name: widget.person.name,
                      knownForDepartment: widget.person.knownForDepartment,
                      birthday: widget.person.birthday,
                      deathday: widget.person.deathday,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                widget.person.biography ?? "No additional info",
                style: Theme.of(context)
                    .extension<ThemeTextStyles>()!
                    .subtitleTextStyle
                    .copyWith(fontSize: 16),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
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
