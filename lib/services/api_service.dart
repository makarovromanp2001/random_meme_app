// Импортируем необходимые пакеты
import 'dart:convert';  // Для преобразования JSON (json.decode)
import 'package:http/http.dart' as http;  // Для HTTP запросов
import '../models/meme_model.dart';  // Импортируем модель мема

// Класс-сервис для общения с API мемов
class ApiService {
  // Базовый URL API (константа, не меняется)
  static const String baseUrl = 'https://api.imgflip.com';

  // Асинхронный метод (Future) - получает список всех мемов из API
  // async - метод может выполняться долго и не блокировать интерфейс
  Future<List<Meme>> fetchMemes() async {
    try {
      // Отправляем GET запрос к API
      final response = await http.get(Uri.parse('$baseUrl/get_memes'));
      
      // Если статус ответа 200 (успех)
      if (response.statusCode == 200) {
        // Преобразуем JSON строку в объект Dart
        final data = json.decode(response.body);
        // Достаем список мемов из JSON (data -> data -> memes)
        final List<dynamic> memesJson = data['data']['memes'];
        // Преобразуем каждый JSON в объект Meme
        return memesJson.map((json) => Meme.fromJson(json)).toList();
      } else {
        // Если API вернул ошибку (не 200)
        throw Exception('Failed to load memes');
      }
    } catch (e) {
      // Ловим любые ошибки (нет интернета и т.д.)
      throw Exception('Network error: $e');
    }
  }

  // Метод для получения случайного мема из списка
  Meme getRandomMeme(List<Meme> memes) {
    // Проверяем, что список не пустой
    if (memes.isEmpty) throw Exception('No memes available');
    
    // Вычисляем случайный индекс
    // Берем текущее время в миллисекундах и делим на длину списка
    // % - оператор остатка от деления
    final randomIndex = DateTime.now().millisecondsSinceEpoch % memes.length;
    
    // Возвращаем мем по случайному индексу
    return memes[randomIndex];
  }
}