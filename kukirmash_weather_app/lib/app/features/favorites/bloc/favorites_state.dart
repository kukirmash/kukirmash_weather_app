part of 'favorites_bloc.dart';

/// Состояния избранного.
sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

/// Начальное состояние — подписка ещё не оформлена.
final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

/// Идёт загрузка списка избранного.
final class FavoritesLoadInProgress extends FavoritesState {
  const FavoritesLoadInProgress();
}

/// Список избранного получен.
final class FavoritesLoadSuccess extends FavoritesState {
  const FavoritesLoadSuccess({required this.favorites});

  final List<FavoriteDay> favorites;

  @override
  List<Object?> get props => [favorites];
}

/// Не удалось получить избранное.
final class FavoritesFailure extends FavoritesState {
  const FavoritesFailure({required this.exception});

  final Object exception;

  @override
  List<Object?> get props => [exception];
}
