import 'favorite_day.dart';

/// Интерфейс репозитория избранных дней (Cloud Firestore).
abstract interface class FavoritesRepositoryInterface {
  /// Поток избранных дней текущего пользователя.
  Stream<List<FavoriteDay>> watchFavorites();

  /// Добавляет день в избранное.
  Future<void> addFavorite(FavoriteDay day);

  /// Удаляет день из избранного.
  Future<void> removeFavorite(String id);
}
