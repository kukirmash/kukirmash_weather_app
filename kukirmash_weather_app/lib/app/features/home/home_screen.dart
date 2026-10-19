import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../data/data.dart';
import '../../../di/di.dart';
import '../../theme/theme.dart';
import '../../widgets/widgets.dart';
import 'bloc/home_bloc.dart';

/// Главный экран — список дней прогноза на неделю.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()..add(const HomeLoadRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: ThemeColors.softBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.location_on_rounded,
                      size: 20,
                      color: ThemeColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Чебоксары',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'Прогноз погоды',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: ThemeColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: ThemeColors.line),
                    ),
                    child: IconButton(
                      tooltip: 'Обновить прогноз',
                      onPressed: () => context.read<HomeBloc>().add(
                        const HomeLoadRequested(),
                      ),
                      icon: const Icon(
                        Icons.refresh_rounded,
                        size: 20,
                        color: ThemeColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return switch (state) {
            HomeInitial() || HomeLoading() => const AppLoading(),
            HomeError(:final exception) => AppError(
              message: exception.toString(),
              onRetry: () =>
                  context.read<HomeBloc>().add(const HomeLoadRequested()),
            ),
            HomeLoaded(:final days, :final updatedAt, :final refreshError) =>
              _HomeContent(
                days: days,
                updatedAt: updatedAt,
                refreshError: refreshError,
              ),
          };
        },
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({
    required this.days,
    required this.updatedAt,
    this.refreshError,
  });

  final List<DailyForecast> days;
  final DateTime updatedAt;
  final Object? refreshError;

  @override
  Widget build(BuildContext context) {
    final today = days.first;
    final rest = days.skip(1).toList();

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 760),
        child: RefreshIndicator(
          color: ThemeColors.primary,
          onRefresh: () => _refresh(context),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (refreshError != null) ...[
                      const RefreshNotice(),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        Text(
                          today.formattedWeekday.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(letterSpacing: 1.2),
                        ),
                        const Spacer(),
                        Text(
                          'Обновлено в ${_formatTime(updatedAt)}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    WeatherHeroCard(
                      forecast: today,
                      eyebrow: today.relativeLabel(DateTime.now()),
                      onTap: () => context.push('/details/${today.id}'),
                    ),
                    const SizedBox(height: 28),
                    SectionTitle(
                      title: 'Прогноз на неделю',
                      trailing: '${days.length} дней',
                    ),
                    const SizedBox(height: 12),
                  ]),
                ),
              ),
              if (rest.isNotEmpty)
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final day = rest[index];
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: index == rest.length - 1 ? 0 : 12,
                        ),
                        child: WeatherCard(
                          forecast: day,
                          onTap: () => context.push('/details/${day.id}'),
                        ),
                      );
                    }, childCount: rest.length),
                  ),
                )
              else
                const SliverToBoxAdapter(child: SizedBox(height: 36)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh(BuildContext context) {
    final completer = Completer<void>();
    context.read<HomeBloc>().add(HomeLoadRequested(completer: completer));
    return completer.future;
  }

  static String _formatTime(DateTime value) =>
      '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}
