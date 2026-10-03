import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'favorite_day.dart';
import 'favorites_repository_interface.dart';

/// Реализация репозитория избранного поверх Cloud Firestore.
///
/// Данные хранятся в подколлекции текущего пользователя:
/// `users/{uid}/favorites/{id}`. Доступ к ней разрешён правилами
/// безопасности только авторизованным пользователям.
class FavoritesRepository implements FavoritesRepositoryInterface {
  FavoritesRepository({required this.available});

  /// Доступен ли Firebase на текущей платформе (см. setUpFirebase).
  final bool available;

  /// Сообщение о недоступности Firebase, показываемое пользователю.
  static const String unavailableMessage =
      'Firebase недоступен на этой платформе или не настроен. '
      'Проверьте файл firebase_options.dart.';

  /// Ленивое обращение к Cloud Firestore.
  FirebaseFirestore get _firestore {
    if (!available) throw const FavoritesException(unavailableMessage);
    return FirebaseFirestore.instance;
  }

  /// Подколлекция избранного текущего пользователя.
  CollectionReference<Map<String, dynamic>> get _favorites {
    if (!available) throw const FavoritesException(unavailableMessage);
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw const FavoritesException('Пользователь не авторизован.');
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites');
  }

  @override
  Stream<List<FavoriteDay>> watchFavorites() {
    return _favorites
        .orderBy('addedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => FavoriteDay.fromJson(doc.data()))
              .toList(),
        );
  }

  @override
  Future<void> addFavorite(FavoriteDay day) async {
    // Идентификатор документа равен дате, поэтому повторное добавление
    // не создаёт дубликат.
    await _favorites.doc(day.id).set(day.toJson());
  }

  @override
  Future<void> removeFavorite(String id) async {
    await _favorites.doc(id).delete();
  }
}

/// Ошибка работы с избранным, показываемая пользователю.
class FavoritesException implements Exception {
  const FavoritesException(this.message);

  final String message;

  @override
  String toString() => message;
}
