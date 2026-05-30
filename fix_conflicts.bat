@echo off
echo Исправление конфликтов в файлах...

cd D:\Forbidden knowlege\crossplatform apps\random_meme_app

:: Исправляем meme_card.dart
powershell -Command "(Get-Content lib/widgets/meme_card.dart) -replace '<<<<<<< HEAD.*?=======.*?>>>>>>>.*?\r?\n', '' | Set-Content lib/widgets/meme_card.dart"

:: Исправляем loading_widget.dart
powershell -Command "(Get-Content lib/widgets/loading_widget.dart) -replace '<<<<<<< HEAD.*?=======.*?>>>>>>>.*?\r?\n', '' | Set-Content lib/widgets/loading_widget.dart"

:: Исправляем home_screen.dart
powershell -Command "(Get-Content lib/screens/home_screen.dart) -replace '<<<<<<< HEAD.*?=======.*?>>>>>>>.*?\r?\n', '' | Set-Content lib/screens/home_screen.dart"

:: Исправляем favorites_screen.dart
powershell -Command "(Get-Content lib/screens/favorites_screen.dart) -replace '<<<<<<< HEAD.*?=======.*?>>>>>>>.*?\r?\n', '' | Set-Content lib/screens/favorites_screen.dart"

:: Исправляем main.dart
powershell -Command "(Get-Content lib/main.dart) -replace '<<<<<<< HEAD.*?=======.*?>>>>>>>.*?\r?\n', '' | Set-Content lib/main.dart"

echo Готово! Теперь запустите flutter clean и flutter run
pause