import 'package:flutter/material.dart';

/// Сообщение об ошибке с кнопкой повторной загрузки.
class AppError extends StatelessWidget {
  const AppError({super.key, required this.description, this.onTap});

  /// Текст ошибки, который увидит пользователь.
  final String description;

  /// Обработчик повторной попытки загрузки.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Icon(
              Icons.cloud_off,
              size: 56,
              color: Theme.of(context).colorScheme.error,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            FilledButton(
              onPressed: onTap,
              child: const Text('Повторить'),
            ),
          ],
        ),
      ),
    );
  }
}
