import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/note.dart';
import '../services/note_storage_service.dart';
import 'notes_event.dart';
import 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  final NoteStorageService storageService;

  NotesBloc({required this.storageService}) : super(NotesState()) {
    on<LoadNotesRequested>(_onLoadNotes);
    on<AddNoteRequested>(_onAddNote);
    on<DeleteNoteRequested>(_onDeleteNote);
  }

  Future<void> _onLoadNotes(
    LoadNotesRequested event,
    Emitter<NotesState> emit,
  ) async {
    emit(state.copyWith(status: NotesStatus.loading, clearError: true));

    try {
      final notes = await storageService.loadNotes();

      emit(NotesState(status: NotesStatus.success, notes: notes));
    } catch (e) {
      emit(
        state.copyWith(
          status: NotesStatus.failure,
          errorMessage: 'Could not load notes.',
        ),
      );
    }
  }

  Future<void> _onAddNote(
    AddNoteRequested event,
    Emitter<NotesState> emit,
  ) async {
    try {
      final note = Note(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        title: event.title,
        content: event.content,
        createdAt: DateTime.now(),
      );

      final updatedNotes = [note, ...state.notes];

      await storageService.saveNotes(updatedNotes);

      emit(NotesState(status: NotesStatus.success, notes: updatedNotes));

      event.completer.complete();
    } catch (e, stackTrace) {
      addError(e, stackTrace);

      event.completer.completeError(Exception('Could not save note.'));
    }
  }

  Future<void> _onDeleteNote(
    DeleteNoteRequested event,
    Emitter<NotesState> emit,
  ) async {
    final originalNotes = state.notes;
    final updatedNotes =
        originalNotes.where((note) => note.id != event.note.id).toList();

    try {
      await storageService.saveNotes(updatedNotes);

      emit(NotesState(status: NotesStatus.success, notes: updatedNotes));
    } catch (e, stackTrace) {
      addError(e, stackTrace);

      emit(
        state.copyWith(
          status: NotesStatus.failure,
          errorMessage: 'Could not delete note.',
        ),
      );
    }
  }
}
