import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/presentation/blocs/person_details_bloc/person_details_bloc.dart';
import 'package:movies_app/core/presentation/components/person/person_details_body.dart';

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
    return BlocProvider(
      create: (context) => PersonDetailsBloc(
        mediaRepository: RepositoryProvider.of<MediaRepository>(context),
      )..add(PersonDetailsLoadDetailsEvent(personId: personId)),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.share))
          ],
        ),
        body: const PersonDetailsBody(),
      ),
    );
  }
}
