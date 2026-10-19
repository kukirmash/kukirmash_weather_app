import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/data.dart';
import '../../../../di/di.dart';

part 'home_event.dart';
part 'home_state.dart';

/// BLoC первого экрана: загружает список дней прогноза.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._forecastRepository) : super(HomeInitial()) {
    on<HomeLoadRequested>(_onLoadRequested);
  }

  final ForecastRepositoryInterface _forecastRepository;

  Future<void> _onLoadRequested(
    HomeLoadRequested event,
    Emitter<HomeState> emit,
  ) async {
    final previous = state;
    if (previous is! HomeLoaded) {
      emit(const HomeLoading());
    }

    try {
      final days = await _forecastRepository.getWeekForecast();
      if (isClosed) return;
      emit(HomeLoaded(days: days, updatedAt: DateTime.now()));
    } catch (exception, stackTrace) {
      talker.handle(exception, stackTrace);
      if (isClosed) return;
      if (state is HomeLoaded) {
        final loaded = state as HomeLoaded;
        emit(
          HomeLoaded(
            days: loaded.days,
            updatedAt: loaded.updatedAt,
            refreshError: exception,
          ),
        );
      } else {
        emit(HomeError(exception: exception));
      }
    } finally {
      event.completer?.complete();
    }
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    super.onError(error, stackTrace);
    talker.handle(error, stackTrace);
  }
}
