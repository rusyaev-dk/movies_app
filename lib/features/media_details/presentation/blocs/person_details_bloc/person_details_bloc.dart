import 'package:bloc/bloc.dart';
import 'package:movies_app/core/domain/models/tmdb_models.dart';
import 'package:movies_app/core/domain/repositories/media_repository.dart';
import 'package:movies_app/core/domain/repositories/repository_failure.dart';

part 'person_details_event.dart';
part 'person_details_state.dart';

class PersonDetailsBloc extends Bloc<PersonDetailsEvent, PersonDetailsState> {
  late final MediaRepository _mediaRepository;

  PersonDetailsBloc({
    required MediaRepository mediaRepository,
  })  : _mediaRepository = mediaRepository,
        super(PersonDetailsState()) {
    on<PersonDetailsLoadDetailsEvent>(_onLoadPersonDetails);
  }

  Future<void> _onLoadPersonDetails(
    PersonDetailsLoadDetailsEvent event,
    Emitter<PersonDetailsState> emit,
  ) async {
    emit(PersonDetailsLoadingState());

    MediaRepositoryPattern mediaRepoPattern =
        await _mediaRepository.onGetMediaDetails<PersonModel>(
      mediaType: TMDBMediaType.person,
      mediaId: event.personId,
      locale: event.locale,
    );

    switch (mediaRepoPattern) {
      case (final ApiRepositoryFailure failure, null):
        return emit(PersonDetailsFailureState(
            failure: failure, personId: event.personId));
      case (null, final PersonModel resPersonModel):
        return emit(PersonDetailsLoadedState(personModel: resPersonModel));
    }
  }
}
