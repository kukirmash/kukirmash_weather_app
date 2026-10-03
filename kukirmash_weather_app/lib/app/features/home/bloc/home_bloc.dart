import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/data.dart';
import '../../../../di/di.dart';

part 'home_event.dart';
part 'home_state.dart';

/// BLoC первого экрана: загружает список дней прогноза.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this.forecastRepository) : super(HomeInitial()) {
    on<HomeLoad>(_homeLoad);
  }

  final ForecastRepositoryInterface forecastRepository;

  Future<void> _homeLoad(HomeLoad event, Emitter<HomeState> emit) async {
    try {
      // При повторной загрузке не прячем уже показанные данные.
      if (state is! HomeLoadSuccess) {
        emit(HomeLoadInProgress());
      }
      final forecast = await forecastRepository.getWeekForecast();
      emit(HomeLoadSuccess(forecast: forecast));
    } catch (exception, stackTrace) {
      emit(HomeLoadFailure(exception: exception));
      talker.handle(exception, stackTrace);
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
