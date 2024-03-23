import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/data/api/api_exceptions.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';
import 'package:movies_app/features/media_details/presentation/blocs/person_details_bloc/person_details_bloc.dart';
import 'package:movies_app/core/presentation/components/failure_widget.dart';
import 'package:movies_app/features/media_details/presentation/components/person/person_info_text.dart';
import 'package:movies_app/core/presentation/formatters/image_formatter.dart';
import 'package:movies_app/core/routing/app_routes.dart';
import 'package:movies_app/core/themes/theme.dart';
import 'package:movies_app/features/auth/presentation/auth_bloc/auth_bloc.dart';
import 'package:shimmer/shimmer.dart';

class PersonDetailsBody extends StatelessWidget {
  const PersonDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PersonDetailsBloc, PersonDetailsState>(
      builder: (context, state) {
        if (state is PersonDetailsFailureState) {
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
                      .read<PersonDetailsBloc>()
                      .add(PersonDetailsLoadDetailsEvent(
                        personId: state.personId!,
                      ));
                },
              );
            default:
              return FailureWidget(failure: state.failure);
          }
        }
        if (state is PersonDetailsLoadingState) {
          return PersonDetailsContent.shimmerLoading(context);
        }

        if (state is PersonDetailsLoadedState) {
          return PersonDetailsContent(person: state.personModel);
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class PersonDetailsContent extends StatelessWidget {
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
        padding: const EdgeInsets.all(0),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
            height: 600,
            width: double.infinity,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 15),
          Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.surface,
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = ApiImageFormatter.formatImageWidget(context,
        imagePath: person.profilePath, width: 100);

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Row(
          children: [
            SizedBox(
              height: 150,
              width: 100,
              child: imageWidget,
            ),
            const SizedBox(width: 20),
            PersonInfoText(
              name: person.name,
              knownForDepartment: person.knownForDepartment,
              birthday: person.birthday,
              deathday: person.deathday,
            ),
          ],
        )
      ],
    );
  }
}
