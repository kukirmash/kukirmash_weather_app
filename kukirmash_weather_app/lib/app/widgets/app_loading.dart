import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Индикатор загрузки с поясняющей подписью.
class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.message = 'Загружаем прогноз'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(strokeWidth: 2.6),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium
                ?.copyWith(color: ThemeColors.muted),
          ),
        ],
      ),
    );
  }
}
