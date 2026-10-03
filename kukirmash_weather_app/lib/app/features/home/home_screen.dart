import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../di/di.dart';
import '../../extensions/extensions.dart';
import '../../widgets/widgets.dart';
import 'bloc/home_bloc.dart';

/// Главный экран приложения (HomeScreen) — список дней прогноза.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _home = getIt<HomeBloc>();

  void loadHome() => _home.add(const HomeLoad());

  @override
  void initState() {
    loadHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Погода')),
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: _home,
        builder: (context, state) {
          return switch (state) {
            HomeInitial() => const SizedBox.shrink(),
            HomeLoadInProgress() => const AppProgressIndicator(),
            HomeLoadSuccess() => _buildHomeLoadSuccess(state),
            HomeLoadFailure() => _buildHomeLoadFailure(state),
          };
        },
      ),
    );
  }

  Widget _buildHomeLoadSuccess(HomeLoadSuccess state) {
    final forecast = state.forecast;

    return RefreshIndicator(
      onRefresh: () {
        final completer = Completer();
        _home.add(HomeLoad(completer: completer));
        return completer.future;
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Чебоксары',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'Прогноз на неделю',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemCount: forecast.length,
              itemBuilder: (_, index) => WeatherCard(
                forecast: forecast[index],
                onTap: () => context.push('/details/${forecast[index].id}'),
              ),
              separatorBuilder: (_, _) => 16.ph,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeLoadFailure(HomeLoadFailure state) {
    return AppError(
      description: state.exception.toString(),
      onTap: loadHome,
    );
  }
}
