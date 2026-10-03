import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/data.dart';
import '../../../di/di.dart';
import '../../extensions/extensions.dart';
import '../../widgets/widgets.dart';
import 'bloc/favorites_bloc.dart';

/// Экран избранных дней, сохранённых в Cloud Firestore.
class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final _favorites = getIt<FavoritesBloc>();

  void loadFavorites() => _favorites.add(const FavoritesStarted());

  @override
  void initState() {
    loadFavorites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Избранное')),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        bloc: _favorites,
        builder: (context, state) {
          return switch (state) {
            FavoritesInitial() => const SizedBox.shrink(),
            FavoritesLoadInProgress() => const AppProgressIndicator(),
            FavoritesLoadSuccess() => _buildLoadSuccess(state),
            FavoritesFailure() => AppError(
              description: state.exception.toString(),
              onTap: loadFavorites,
            ),
          };
        },
      ),
    );
  }

  Widget _buildLoadSuccess(FavoritesLoadSuccess state) {
    final favorites = state.favorites;

    if (favorites.isEmpty) {
      return const _FavoritesEmpty();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: favorites.length,
      itemBuilder: (_, index) => _FavoriteTile(
        favorite: favorites[index],
        onRemove: () => _favorites.add(
          FavoriteRemoveRequested(id: favorites[index].id),
        ),
      ),
      separatorBuilder: (_, _) => 12.ph,
    );
  }
}

/// Заглушка, показываемая когда в избранном нет ни одного дня.
class _FavoritesEmpty extends StatelessWidget {
  const _FavoritesEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            const Icon(Icons.bookmark_border, size: 56),
            Text(
              'В избранном пока пусто',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Откройте подробный прогноз дня и нажмите на закладку, '
              'чтобы сохранить его здесь.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Строка списка избранного.
class _FavoriteTile extends StatelessWidget {
  const _FavoriteTile({required this.favorite, required this.onRemove});

  final FavoriteDay favorite;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F6F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        spacing: 12,
        children: [
          Expanded(
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  favorite.id,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  favorite.condition,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                  ),
                ),
                Text(
                  'Днём ${favorite.temperatureMax.round()}°C · '
                  'ночью ${favorite.temperatureMin.round()}°C',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Удалить из избранного',
            onPressed: onRemove,
            icon: const Icon(Icons.bookmark_remove_outlined),
          ),
        ],
      ),
    );
  }
}
