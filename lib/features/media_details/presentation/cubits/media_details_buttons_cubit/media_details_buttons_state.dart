part of 'media_details_buttons_cubit.dart';

class MediaDetailsButtonsState {
  final bool favourite;
  final bool watchlist;

  MediaDetailsButtonsState({
    required this.favourite,
    required this.watchlist,
  });

  MediaDetailsButtonsState copyWith({
    bool? favourite,
    bool? watchlist,
  }) {
    return MediaDetailsButtonsState(
      favourite: favourite ?? this.favourite,
      watchlist: watchlist ?? this.watchlist,
    );
  }
}
