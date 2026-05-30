import 'package:flutter/material.dart';
import '../services/favorites_service.dart';
import '../models/meme_model.dart';
import '../widgets/meme_card.dart';

class FavoritesScreen extends StatefulWidget {
  final FavoritesService favoritesService;

  const FavoritesScreen({Key? key, required this.favoritesService}) 
    : super(key: key);

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Meme> _favorites = [];  // Список избранных мемов
  bool _isLoading = true;      // Флаг загрузки

  @override
  void initState() {
    super.initState();
    _loadFavorites();  // Загружаем избранное
  }

  // Загрузка избранного из хранилища
  Future<void> _loadFavorites() async {
    final favorites = await widget.favoritesService.getFavorites();
    setState(() {
      _favorites = favorites;
      _isLoading = false;
    });
  }

  // Удаление из избранного
  Future<void> _removeFromFavorites(String memeId) async {
    await widget.favoritesService.removeFavorite(memeId);
    _loadFavorites();  // Перезагружаем список
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: _isLoading
          // Пока загружается - показываем спиннер
          ? const Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              // Если избранное пусто - показываем красивую заглушку
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text('Add some memes from the home screen'),
                    ],
                  ),
                )
              // Список избранных мемов
              : ListView.builder(
                  itemCount: _favorites.length,  // Количество элементов
                  itemBuilder: (context, index) {
                    final meme = _favorites[index];
                    return FutureBuilder<bool>(
                      // Проверяем в избранном (всегда true, но для единообразия)
                      future: widget.favoritesService.isFavorite(meme.id),
                      builder: (context, snapshot) {
                        return MemeCard(
                          meme: meme,
                          isFavorite: true,  // Всегда в избранном
                          onFavoriteToggle: () => _removeFromFavorites(meme.id),
                        );
                      },
                    );
                  },
                ),
    );
  }
}