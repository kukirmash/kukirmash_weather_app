import 'package:flutter/material.dart';

/// Индикатор загрузки, используемый на экранах приложения.
class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
