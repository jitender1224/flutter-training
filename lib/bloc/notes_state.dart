import '../models/note.dart';

enum NotesStatus { initial, loading, success, failure }

class NotesState {
  final NotesStatus status;
  final List<Note> notes;
  final String? errorMessage;

  NotesState({
    this.status = NotesStatus.initial,
    List<Note> notes = const [],
    this.errorMessage,
  }) : notes = List.unmodifiable(notes);

  NotesState copyWith({
    NotesStatus? status,
    List<Note>? notes,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotesState(
      status: status ?? this.status,
      notes: notes ?? this.notes,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}
