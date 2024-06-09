part of 'person_details_bloc.dart';

sealed class PersonDetailsEvent extends Equatable {}

final class PersonDetailsLoadDetailsEvent extends PersonDetailsEvent {
  final String locale;
  final int personId;

  PersonDetailsLoadDetailsEvent({
    this.locale = "en-US",
    required this.personId,
  });

  @override
  List<Object?> get props => [
        locale,
        personId,
      ];
}
