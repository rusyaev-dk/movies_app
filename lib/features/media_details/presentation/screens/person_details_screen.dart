import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:movies_app/common/domain/repositories/media_repository.dart';
import 'package:movies_app/features/media_details/presentation/blocs/person_details_bloc/person_details_bloc.dart';
import 'package:movies_app/features/media_details/presentation/components/person/person_details_appbar.dart';
import 'package:movies_app/features/media_details/presentation/components/person/person_details_body.dart';
import 'package:movies_app/features/media_details/presentation/cubits/media_details_appbar_cubit/media_details_appbar_cubit.dart';

class PersonDetailsScreen extends StatelessWidget {
  const PersonDetailsScreen({
    super.key,
    required this.personId,
    required this.appBarTitle,
  });

  final int personId;
  final String appBarTitle;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PersonDetailsBloc(
            mediaRepository: GetIt.I<MediaRepository>(),
          )..add(PersonDetailsLoadDetailsEvent(personId: personId)),
        ),
        BlocProvider(
          create: (context) => MediaDetailsAppbarCubit(),
        ),
      ],
      child: Scaffold(
        appBar: PersonDetailsAppBar(appBarTitle: appBarTitle),
        body: const PersonDetailsBody(),
      ),
    );
  }
}
