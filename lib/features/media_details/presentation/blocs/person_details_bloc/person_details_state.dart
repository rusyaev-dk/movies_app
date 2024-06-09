part of 'person_details_bloc.dart';

sealed class PersonDetailsState extends Equatable {}

final class PersonDetailsLoadingState extends PersonDetailsState {
  @override
  List<Object?> get props => [];
}

final class PersonDetailsLoadedState extends PersonDetailsState {
  final PersonModel personModel;

  PersonDetailsLoadedState({
    required this.personModel,
  });

  @override
  List<Object?> get props => [personModel];
}

final class PersonDetailsFailureState extends PersonDetailsState {
  final ApiRepositoryFailure failure;
  final int? personId;

  PersonDetailsFailureState({
    required this.failure,
    this.personId,
  });
  
  @override
  List<Object?> get props => [failure];
}
