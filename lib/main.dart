import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/dio_client.dart';
import 'features/news/data/repositories/news_repository.dart';
import 'features/news/presentation/bloc/news_bloc.dart';
import 'features/news/presentation/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final api = createNewsApi();
  final repository = NewsRepository(api);

  runApp(DailyNewsApp(repository: repository));
}

class DailyNewsApp extends StatelessWidget {
  final NewsRepository repository;

  const DailyNewsApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
      ),
      home: BlocProvider(
        create: (_) => NewsBloc(repository),
        child: const HomeScreen(),
      ),
    );
  }
}
