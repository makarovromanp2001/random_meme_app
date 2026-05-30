import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/meme_model.dart';

// StatelessWidget - виджет без состояния (не меняется сам)
class MemeCard extends StatelessWidget {
  // Параметры, передаваемые в виджет
  final Meme meme;              // Данные мема
  final bool isFavorite;        // В избранном или нет
  final VoidCallback onFavoriteToggle;  // Функция при нажатии лайка

  // Конструктор с обязательными параметрами
  const MemeCard({
    Key? key,
    required this.meme,
    required this.isFavorite,
    required this.onFavoriteToggle,
  }) : super(key: key);

  // Основной метод построения UI
  @override
  Widget build(BuildContext context) {
    // Получаем размер экрана
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Card(  // Карточка с тенью
      elevation: 4,  // Поднятие (тень)
      margin: const EdgeInsets.all(16),  // Отступы со всех сторон
      shape: RoundedRectangleBorder(  // Скругленные углы
        borderRadius: BorderRadius.circular(12)
      ),
      child: LayoutBuilder(  // Адаптивный контейнер
        builder: (context, constraints) {
          // Высота картинки: 65% от высоты экрана, но не меньше 250 и не больше 600
          final imageHeight = (screenHeight * 0.65).clamp(250.0, 600.0);
          
          return Column(
            mainAxisSize: MainAxisSize.min,  // Минимальная высота
            children: [
              // Контейнер с картинкой
              SizedBox(
                width: double.infinity,  // На всю ширину
                height: imageHeight,     // Фиксированная высота
                child: ClipRRect(  // Обрезает по кругу
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: meme.url,  // URL картинки
                    // Что показывать во время загрузки
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    // Что показывать при ошибке
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, size: 50, color: Colors.red),
                            SizedBox(height: 8),
                            Text('Failed to load image'),
                          ],
                        ),
                      ),
                    ),
                    fit: BoxFit.contain,  // Вписываем картинку без обрезки
                  ),
                ),
              ),
              // Нижняя панель с названием и кнопкой
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,  // Цвет из темы
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    // Название мема (растягивается)
                    Expanded(
                      child: Text(
                        meme.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.3,
                        ),
                        maxLines: 2,  // Максимум 2 строки
                        overflow: TextOverflow.ellipsis,  // ... если не влезает
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Кнопка лайка
                    Material(
                      color: Colors.transparent,  // Прозрачный фон
                      child: InkWell(  // С эффектом нажатия
                        onTap: onFavoriteToggle,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            // Меняем иконку в зависимости от isFavorite
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey.shade600,
                            size: 30,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}