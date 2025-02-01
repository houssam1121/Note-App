import 'package:authentication_test/repository/add_edit_repository.dart';
import 'package:flutter/material.dart';
import '../models/note_model.dart';


class NoteViewModel extends ChangeNotifier {
  final NoteRepository _noteRepository = NoteRepository();

  // Stream of notes
  Stream<List<Note>> get notesStream => _noteRepository.getNotes();

  // Add a new note
  Future<void> addNote(String title, String content) async {
    final note = Note(
       userId: '', // Will be set in the repository
      title: title,
      content: content,
      timestamp: DateTime.now(),
    );
    await _noteRepository.addNote(note);
    notifyListeners(); // Notify listeners after adding a note
  }

  // Update an existing note
  Future<void> updateNote(Note note) async {
    await _noteRepository.updateNote(note);
    notifyListeners(); // Notify listeners after updating a note
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    await _noteRepository.deleteNote(noteId);
    notifyListeners(); // Notify listeners after deleting a note
  }
}