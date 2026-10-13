
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFAFAFA),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: const NotesHomePage(),
    );
  }
}

class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class NotesHomePage extends StatefulWidget {
  const NotesHomePage({super.key});

  @override
  State<NotesHomePage> createState() => _NotesHomePageState();
}

class _NotesHomePageState extends State<NotesHomePage> {
  static const String _storageKey = 'saved_notes';

  List<Note> _notes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  // Load notes when the app opens.
  Future<void> _loadNotes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedData = prefs.getString(_storageKey);

      if (savedData != null) {
        final List<dynamic> decoded = jsonDecode(savedData);

        _notes = decoded
            .map((item) => Note.fromJson(
          Map<String, dynamic>.from(item),
        ))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading notes: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Save the complete list locally.
  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      _notes.map((note) => note.toJson()).toList(),
    );

    await prefs.setString(_storageKey, encoded);
  }

  // Add a new note.
  Future<void> _addNote(String title, String content) async {
    final note = Note(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
    );

    setState(() {
      _notes.insert(0, note);
    });

    try {
      await _saveNotes();
    } catch (e) {
      if (mounted) {
        setState(() {
          _notes.removeWhere((item) => item.id == note.id);
        });
      }
      rethrow;
    }
  }

  // Delete a note.
  Future<void> _deleteNote(Note note) async {
    final originalIndex = _notes.indexOf(note);

    setState(() {
      _notes.remove(note);
    });

    try {
      await _saveNotes();
    } catch (e) {
      if (mounted) {
        setState(() {
          _notes.insert(originalIndex, note);
        });
      }
    }
  }

  Future<void> _openAddNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddNotePage(onSave: _addNote),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Notes',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : _notes.isEmpty
          ? const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.note_alt_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              'No notes yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Tap + to create your first note',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _notes.length,
        separatorBuilder: (_, __) =>
        const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final note = _notes[index];

          return Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(
                color: Color(0xFFEEEEEE),
              ),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                note.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  note.content,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.grey,
                ),
                onPressed: () => _deleteNote(note),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddNote,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddNotePage extends StatefulWidget {
  final Future<void> Function(String title, String content) onSave;

  const AddNotePage({
    super.key,
    required this.onSave,
  });

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  bool _isSaving = false;

  Future<void> _save() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title or note'),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      await widget.onSave(
        title.isEmpty ? 'Untitled' : title,
        content,
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save note. Please try again.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _isSaving
              ? null
              : () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
                : const Text(
              'Save',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              autofocus: true,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _contentController,
                expands: true,
                maxLines: null,
                minLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Start writing...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}