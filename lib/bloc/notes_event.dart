import 'dart:async';

import '../models/note.dart';

abstract class NotesEvent {}

class LoadNotesRequested extends NotesEvent {}

class AddNoteRequested extends NotesEvent {
  final String title;
  final String content;
  final Completer<void> completer;

  AddNoteRequested({
    required this.title,
    required this.content,
    required this.completer,
  });
}

class DeleteNoteRequested extends NotesEvent {
  final Note note;

  DeleteNoteRequested(this.note);
}
