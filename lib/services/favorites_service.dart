import 'dart:convert';  // Для работы с JSON
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meme_model.dart';

// Сервис для сохранения/загрузки избранных мемов
class FavoritesService {
  // Ключ для хранения в SharedPreferences
  static const String _favoritesKey = 'favorites';
  
  // Ссылка на SharedPreferences (хранилище)
  final SharedPreferences _prefs;

  // Конструктор - получаем готовый экземпляр SharedPreferences
  FavoritesService(this._prefs);

  // Получить все избранные мемы
  Future<List<Meme>> getFavorites() async {
    // Достаем строку JSON из хранилища по ключу
    final String? favoritesJson = _prefs.getString(_favoritesKey);
    
    // Если ничего нет - возвращаем пустой список
    if (favoritesJson == null) return [];
    
    // Преобразуем JSON в список объектов Dart
    final List<dynamic> decoded = json.decode(favoritesJson);
    
    // Преобразуем каждый элемент в объект Meme
    return decoded.map((json) => Meme.fromJson(json)).toList();
  }

  // Добавить мем в избранное
  Future<void> addFavorite(Meme meme) async {
    // Получаем текущий список избранного
    final favorites = await getFavorites();
    
    // Проверяем, нет ли уже такого мема (по id)
    // any() - проверяет, есть ли хоть один элемент, соответствующий условию
    if (!favorites.any((m) => m.id == meme.id)) {
      favorites.add(meme);  // Добавляем мем
      await _saveFavorites(favorites);  // Сохраняем обновленный список
    }
  }

  // Удалить мем из избранного по id
  Future<void> removeFavorite(String memeId) async {
    final favorites = await getFavorites();
    // removeWhere - удаляет все элементы, подходящие под условие
    favorites.removeWhere((meme) => meme.id == memeId);
    await _saveFavorites(favorites);
  }

  // Проверить, находится ли мем в избранном
  Future<bool> isFavorite(String memeId) async {
    final favorites = await getFavorites();
    // Проверяем, есть ли мем с таким id
    return favorites.any((meme) => meme.id == memeId);
  }

  // Приватный метод (_) - сохраняет список избранного
  Future<void> _saveFavorites(List<Meme> favorites) async {
    // Преобразуем объекты Meme в JSON
    final String encoded = json.encode(
      favorites.map((meme) => {
        'id': meme.id,
        'name': meme.name,
        'url': meme.url,
        'width': meme.width,
        'height': meme.height,
        'box_count': meme.boxCount,
      }).toList()
    );
    // Сохраняем строку JSON в SharedPreferences
    await _prefs.setString(_favoritesKey, encoded);
  }
}