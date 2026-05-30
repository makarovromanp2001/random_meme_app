import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/favorites_service.dart';
import '../models/meme_model.dart';
import '../widgets/meme_card.dart';
import '../widgets/loading_widget.dart';

// StatefulWidget - виджет с состоянием (может меняться)
class HomeScreen extends StatefulWidget {
  final FavoritesService favoritesService;

  const HomeScreen({Key? key, required this.favoritesService}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Состояние для HomeScreen
class _HomeScreenState extends State<HomeScreen> {
  // Сервисы и переменные состояния
  final ApiService _apiService = ApiService();  // API сервис
  List<Meme>? _allMemes;    // Все мемы (может быть null)
  Meme? _currentMeme;       // Текущий отображаемый мем
  bool _isLoading = true;   // Идет загрузка?
  String? _error;           // Ошибка (если есть)

  // Вызывается при создании виджета (один раз)
  @override
  void initState() {
    super.initState();
    _loadMemes();  // Начинаем загрузку мемов
  }

  // Загрузка всех мемов из API
  Future<void> _loadMemes() async {
    try {
      final memes = await _apiService.fetchMemes();  // Получаем мемы
      setState(() {  // Обновляем состояние (перерисовываем UI)
        _allMemes = memes;
        _currentMeme = _apiService.getRandomMeme(memes);  // Выбираем случайный
        _isLoading = false;  // Загрузка закончена
      });
    } catch (e) {
      setState(() {
        _error = e.toString();  // Сохраняем ошибку
        _isLoading = false;
      });
    }
  }

  // Загрузить новый случайный мем
  void _loadNewMeme() {
    if (_allMemes != null) {
      setState(() {
        _currentMeme = _apiService.getRandomMeme(_allMemes!);
      });
    }
  }

  // Добавить/удалить из избранного
  Future<void> _toggleFavorite() async {
    if (_currentMeme == null) return;
    
    // Проверяем, в избранном ли уже
    final isFav = await widget.favoritesService.isFavorite(_currentMeme!.id);
    if (isFav) {
      await widget.favoritesService.removeFavorite(_currentMeme!.id);
    } else {
      await widget.favoritesService.addFavorite(_currentMeme!);
    }
    setState(() {});  // Обновляем UI
  }

  @override
  Widget build(BuildContext context) {
    // Показываем загрузку
    if (_isLoading) {
      return const LoadingWidget();
    }

    // Показываем ошибку
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isLoading = true;  // Пробуем снова
                  _error = null;
                  _loadMemes();
                });
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Основной UI
    return Scaffold(  // Каркас экрана
      appBar: AppBar(  // Верхняя панель
        title: const Text('Random Meme'),
        centerTitle: true,
        elevation: 2,
      ),
      // Тело экрана
      body: _currentMeme != null
        ? Column(
            children: [
              // Контент занимает всё доступное место
              Expanded(
                child: SingleChildScrollView(  // Скролл если не влезает
                  child: FutureBuilder<bool>(  // Асинхронно проверяем isFavorite
                    future: widget.favoritesService.isFavorite(_currentMeme!.id),
                    builder: (context, snapshot) {
                      final isFavorite = snapshot.data ?? false;
                      return MemeCard(
                        meme: _currentMeme!,
                        isFavorite: isFavorite,
                        onFavoriteToggle: _toggleFavorite,
                      );
                    },
                  ),
                ),
              ),
              // Кнопка "Next Meme" всегда внизу
              SafeArea(  // Защита от системных панелей
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton.icon(
                    onPressed: _loadNewMeme,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Next Meme'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),  // На всю ширину
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          )
        : const SizedBox.shrink(),  // Ничего не показываем (запасной вариант)
    );
  }
}