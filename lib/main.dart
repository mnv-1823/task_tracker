import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_tracker/task_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ThemeModeNotifier>(
      create: (_) => ThemeModeNotifier(),
      child: Consumer<ThemeModeNotifier>(
        builder: (_, notifier, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Task Tracker',
            theme: ThemeData.dark(),
            darkTheme: ThemeData.light(),
            themeMode: notifier.mode,
            home: TaskListScreen(),
          );
        },
      ),
    );
  }
}

class ThemeModeNotifier with ChangeNotifier {
  ThemeMode _mode = ThemeMode.light;

  ThemeMode get mode => _mode;

  void toggleMode() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
