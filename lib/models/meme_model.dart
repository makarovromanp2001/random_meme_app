// Определяем класс Meme - шаблон для создания объектов мемов
class Meme {
  // Поля класса (характеристики мема)
  final String id;        // Уникальный идентификатор (например: "181913649")
  final String name;      // Название мема (например: "Drake Hotline Bling")
  final String url;       // Ссылка на картинку с мемом
  final int width;        // Ширина картинки в пикселях
  final int height;       // Высота картинки в пикселях
  final int boxCount;     // Количество текстовых полей в меме

  // Конструктор - метод создания объекта
  // required - параметры обязательны при создании
  Meme({
    required this.id,
    required this.name,
    required this.url,
    required this.width,
    required this.height,
    required this.boxCount,
  });

  // Фабричный метод - создает мем из JSON (данных от API)
  // factory - возвращает объект класса
  factory Meme.fromJson(Map<String, dynamic> json) {
    return Meme(
      id: json['id'].toString(),  // Преобразуем в строку для безопасности
      name: json['name'],
      url: json['url'],
      width: json['width'],
      height: json['height'],
      boxCount: json['box_count'],  // В API называется box_count
    );
  }
}