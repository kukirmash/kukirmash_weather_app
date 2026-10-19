import 'package:flutter/material.dart';

import '../theme/theme.dart';

/// Заголовок раздела с необязательной подписью справа.
class SectionTitle extends StatelessWidget {
  const SectionTitle({super.key, required this.title, this.trailing});

  final String title;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        if (trailing != null)
          Text(
            trailing!,
            style: Theme.of(context).textTheme.labelSmall
                ?.copyWith(color: ThemeColors.muted),
          ),
      ],
    );
  }
}
