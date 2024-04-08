part of 'person_details_bloc.dart';

class PersonDetailsState {}

class PersonDetailsLoadingState extends PersonDetailsState {}

class PersonDetailsLoadedState extends PersonDetailsState {
  final PersonModel personModel;

  PersonDetailsLoadedState({
    required this.personModel,
  });
}

class PersonDetailsFailureState extends PersonDetailsState {
  final ApiRepositoryFailure failure;
  final int? personId;

  PersonDetailsFailureState({
    required this.failure,
    this.personId,
  });
}
