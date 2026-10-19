import 'package:flutter/material.dart';

/// Ненавязчивое уведомление о неудачном фоновом обновлении.
class RefreshNotice extends StatelessWidget {
  const RefreshNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF6E8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3D9AA)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: Color(0xFF9A6B16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Не удалось обновить прогноз. Показаны предыдущие данные.',
              style: Theme.of(context).textTheme.bodySmall
                  ?.copyWith(color: const Color(0xFF7A5817)),
            ),
          ),
        ],
      ),
    );
  }
}
