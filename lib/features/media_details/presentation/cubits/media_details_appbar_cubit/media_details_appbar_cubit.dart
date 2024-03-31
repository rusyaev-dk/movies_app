import 'package:bloc/bloc.dart';

enum MediaDetailsAppbarState { filled, transparent }

class MediaDetailsAppbarCubit extends Cubit<MediaDetailsAppbarState> {
  MediaDetailsAppbarCubit() : super(MediaDetailsAppbarState.transparent);

  void fillAppBar() {
    emit(MediaDetailsAppbarState.filled);
  }

  void unFillAppBar() {
    emit(MediaDetailsAppbarState.transparent);
  }
}
