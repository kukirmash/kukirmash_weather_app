import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/data.dart';
import '../../../../di/di.dart';

part 'details_event.dart';
part 'details_state.dart';

/// BLoC второго экрана: загружает подробности выбранного дня.
class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  DetailsBloc(this._forecastRepository) : super(DetailsInitial()) {
    on<DetailsLoadRequested>(_onLoadRequested);
  }

  final ForecastRepositoryInterface _forecastRepository;

  Future<void> _onLoadRequested(
    DetailsLoadRequested event,
    Emitter<DetailsState> emit,
  ) async {
    final previous = state;
    final loaded =
        previous is DetailsLoaded && previous.details.summary.id == event.id
        ? previous
        : null;

    if (loaded == null) {
      emit(const DetailsLoading());
    }

    try {
      final details = await _forecastRepository.getDayDetails(event.id);
      if (isClosed) return;
      emit(DetailsLoaded(details: details));
    } catch (exception, stackTrace) {
      talker.handle(exception, stackTrace);
      if (isClosed) return;
      if (loaded != null) {
        emit(DetailsLoaded(details: loaded.details, refreshError: exception));
      } else {
        emit(DetailsError(exception: exception));
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
