import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/data.dart';
import '../../../../di/di.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

/// BLoC избранного: слушает коллекцию Cloud Firestore текущего пользователя
/// и добавляет/удаляет избранные дни.
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc(this.favoritesRepository) : super(const FavoritesInitial()) {
    on<FavoritesStarted>(_favoritesStarted);
    on<FavoriteAddRequested>(_favoriteAddRequested);
    on<FavoriteRemoveRequested>(_favoriteRemoveRequested);
  }

  final FavoritesRepositoryInterface favoritesRepository;

  Future<void> _favoritesStarted(
    FavoritesStarted event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(const FavoritesLoadInProgress());
    try {
      // emit.forEach держит обработчик подписанным на поток до его закрытия,
      // поэтому список обновляется автоматически при любом изменении в базе.
      await emit.forEach<List<FavoriteDay>>(
        favoritesRepository.watchFavorites(),
        onData: (favorites) => FavoritesLoadSuccess(favorites: favorites),
        onError: (Object error, StackTrace stackTrace) {
          talker.handle(error, stackTrace);
          return FavoritesFailure(exception: error);
        },
      );
    } catch (exception, stackTrace) {
      emit(FavoritesFailure(exception: exception));
      talker.handle(exception, stackTrace);
    }
  }

  Future<void> _favoriteAddRequested(
    FavoriteAddRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await favoritesRepository.addFavorite(
        FavoriteDay.fromForecast(event.forecast),
      );
    } catch (exception, stackTrace) {
      emit(FavoritesFailure(exception: exception));
      talker.handle(exception, stackTrace);
    }
  }

  Future<void> _favoriteRemoveRequested(
    FavoriteRemoveRequested event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await favoritesRepository.removeFavorite(event.id);
    } catch (exception, stackTrace) {
      emit(FavoritesFailure(exception: exception));
      talker.handle(exception, stackTrace);
    }
  }
}
