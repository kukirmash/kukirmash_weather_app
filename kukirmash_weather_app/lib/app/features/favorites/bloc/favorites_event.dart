part of 'favorites_bloc.dart';

/// События избранного.
sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

/// Подписка на коллекцию избранного текущего пользователя.
class FavoritesStarted extends FavoritesEvent {
  const FavoritesStarted();
}

/// Добавить день прогноза в избранное.
class FavoriteAddRequested extends FavoritesEvent {
  const FavoriteAddRequested({required this.forecast});

  final DailyForecast forecast;

  @override
  List<Object?> get props => [forecast];
}

/// Удалить день из избранного по его идентификатору.
class FavoriteRemoveRequested extends FavoritesEvent {
  const FavoriteRemoveRequested({required this.id});

  final String id;

  @override
  List<Object?> get props => [id];
}
