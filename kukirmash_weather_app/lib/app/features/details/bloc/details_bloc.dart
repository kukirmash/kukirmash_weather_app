import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/data.dart';
import '../../../../di/di.dart';

part 'details_event.dart';
part 'details_state.dart';

/// BLoC второго экрана: загружает подробные данные выбранного дня.
class DetailsBloc extends Bloc<DetailsEvent, DetailsState> {
  DetailsBloc(this.forecastRepository) : super(DetailsInitial()) {
    on<DetailsLoad>(_detailsLoad);
  }

  final ForecastRepositoryInterface forecastRepository;

  Future<void> _detailsLoad(DetailsLoad event, Emitter<DetailsState> emit) async {
    try {
      emit(DetailsLoadInProgress());
      final details = await forecastRepository.getDayDetails(event.id);
      emit(DetailsLoadSuccess(details: details));
    } catch (exception, stackTrace) {
      emit(DetailsLoadFailure(exception: exception));
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
