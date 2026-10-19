import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kukirmash_weather_app/app/features/details/bloc/details_bloc.dart';
import 'package:kukirmash_weather_app/app/features/home/bloc/home_bloc.dart';
import 'package:kukirmash_weather_app/data/data.dart';

import '../helpers/fixtures.dart';

void main() {
  group('HomeBloc', () {
    test('загружает прогноз и публикует HomeLoaded', () async {
      final repository = FakeForecastRepository();
      final bloc = HomeBloc(repository);

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HomeLoading>(),
          isA<HomeLoaded>()
              .having((state) => state.days, 'days', hasLength(1))
              .having((state) => state.refreshError, 'refreshError', isNull),
        ]),
      );

      bloc.add(const HomeLoadRequested());
      await expectation;

      expect(repository.weekCalls, 1);
      await bloc.close();
    });

    test('не публикует состояние после закрытия блока', () async {
      final repository = _DelayedForecastRepository();
      final bloc = HomeBloc(repository);

      bloc.add(const HomeLoadRequested());
      await Future<void>.delayed(Duration.zero);
      await bloc.close();

      repository.week.complete([sampleDay()]);
      await Future<void>.delayed(Duration.zero);
      expect(bloc.isClosed, isTrue);
    });

    test('публикует HomeError, если загрузка не удалась', () async {
      final repository = FakeForecastRepository()..shouldFail = true;
      final bloc = HomeBloc(repository);

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<HomeLoading>(),
          isA<HomeError>().having(
            (state) => state.exception.toString(),
            'exception',
            'Тестовая ошибка загрузки',
          ),
        ]),
      );

      bloc.add(const HomeLoadRequested());
      await expectation;

      await bloc.close();
    });
  });

  group('DetailsBloc', () {
    test('загружает подробности дня', () async {
      final repository = FakeForecastRepository();
      final bloc = DetailsBloc(repository);

      final expectation = expectLater(
        bloc.stream,
        emitsInOrder([
          isA<DetailsLoading>(),
          isA<DetailsLoaded>()
              .having(
                (state) => state.details.summary.id,
                'summary id',
                '2026-10-19',
              )
              .having((state) => state.details.hourly, 'hourly', hasLength(2)),
        ]),
      );

      bloc.add(const DetailsLoadRequested(id: '2026-10-19'));
      await expectation;

      expect(repository.detailsCalls, 1);
      await bloc.close();
    });

    test('не публикует состояние после закрытия блока', () async {
      final repository = _DelayedForecastRepository();
      final bloc = DetailsBloc(repository);

      bloc.add(const DetailsLoadRequested(id: '2026-10-19'));
      await Future<void>.delayed(Duration.zero);
      await bloc.close();

      repository.details.complete(sampleDetails());
      await Future<void>.delayed(Duration.zero);
      expect(bloc.isClosed, isTrue);
    });

    test('сохраняет данные при ошибке обновления', () async {
      final repository = FakeForecastRepository();
      final bloc = DetailsBloc(repository);

      final loadedFuture = bloc.stream.firstWhere(
        (state) => state is DetailsLoaded,
      );
      bloc.add(const DetailsLoadRequested(id: '2026-10-19'));
      final loaded = await loadedFuture;
      expect(loaded, isA<DetailsLoaded>());

      repository.shouldFail = true;
      final expectation = expectLater(
        bloc.stream,
        emits(
          isA<DetailsLoaded>()
              .having((state) => state.refreshError, 'refreshError', isNotNull)
              .having((state) => state.details.hourly, 'hourly', hasLength(2)),
        ),
      );

      bloc.add(const DetailsLoadRequested(id: '2026-10-19'));
      await expectation;

      await bloc.close();
    });
  });
}

class _DelayedForecastRepository implements ForecastRepositoryInterface {
  final Completer<List<DailyForecast>> week = Completer();
  final Completer<DayDetails> details = Completer();

  @override
  Future<List<DailyForecast>> getWeekForecast() => week.future;

  @override
  Future<DayDetails> getDayDetails(String id) => details.future;
}
