import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/favorites_service.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';

// main - функция, с которой начинается выполнение программы
// async - программа ждет инициализацию
void main() async {
  // Обеспечивает инициализацию плагинов (важно для веба)
  WidgetsFlutterBinding.ensureInitialized();
  
  // Загружаем SharedPreferences (локальное хранилище)
  final prefs = await SharedPreferences.getInstance();
  
  // Создаем сервис для избранного с этим хранилищем
  final favoritesService = FavoritesService(prefs);
  
  // Запускаем приложение
  runApp(MyApp(favoritesService: favoritesService));
}

// Главный виджет приложения
class MyApp extends StatelessWidget {
  final FavoritesService favoritesService;

  const MyApp({Key? key, required this.favoritesService}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // MaterialApp - корневой виджет Material Design
    return MaterialApp(
      title: 'Random Meme App',
      theme: ThemeData(  // Настройка темы
        primarySwatch: Colors.blue,  // Основной цвет (синий)
        useMaterial3: true,  // Используем новую версию Material
      ),
      home: MainScreen(favoritesService: favoritesService),  // Начальный экран
    );
  }
}

// Основной экран с нижней навигацией
class MainScreen extends StatefulWidget {
  final FavoritesService favoritesService;

  const MainScreen({Key? key, required this.favoritesService}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;  // Выбранный индекс (0 - Home, 1 - Favorites)

  // Список экранов (создается поздно для избежания ошибок)
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Инициализируем экраны с переданным сервисом
    _screens = [
      HomeScreen(favoritesService: widget.favoritesService),
      FavoritesScreen(favoritesService: widget.favoritesService),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],  // Показываем выбранный экран
      bottomNavigationBar: NavigationBar(  // Нижняя навигация
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {  // Меняем состояние
            _selectedIndex = index;  // Переключаем экран
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}