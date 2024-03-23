part of 'person_details_bloc.dart';

class PersonDetailsEvent {}

class PersonDetailsLoadDetailsEvent extends PersonDetailsEvent {
  final String locale;
  final int personId;

  PersonDetailsLoadDetailsEvent({
    this.locale = "en-US",
    required this.personId,
  });
}

