import 'package:flutter/material.dart';

// Простой виджет-заглушка на время загрузки
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Center - центрирует дочерний виджет
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,  // Центрируем по вертикали
        children: [
          CircularProgressIndicator(),  // Крутящийся индикатор
          SizedBox(height: 16),  // Отступ
          Text('Loading memes...'),  // Текст
        ],
      ),
    );
  }
}