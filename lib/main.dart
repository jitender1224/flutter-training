import 'package:flutter/material.dart';

import 'screens/notes_home_page.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAFAFA),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const NotesHomePage(),
    );
  }
}
