import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';

class NoteStorageService {
  static const String _storageKey = 'saved_notes';

  Future<List<Note>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString(_storageKey);

    if (savedData == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(savedData);

    return decoded.map((item) {
      return Note.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }

  Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(notes.map((note) => note.toJson()).toList());

    await prefs.setString(_storageKey, encoded);
  }
}
