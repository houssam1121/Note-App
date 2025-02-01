import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/note_model.dart';

class NoteRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Collection reference
  CollectionReference get _notesCollection => _firestore.collection('notes');

  // // Add a new note
  // Future<void> addNote(Note note) async {

  //   await _notesCollection.add(note.toMap());
  // }
  // Add a new note
  Future<void> addNote(Note note) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _notesCollection.add({
      ...note.toMap(),
      'userId': user.uid, // Add the user ID to the note
    });
  }

  // Update an existing note
  Future<void> updateNote(Note note) async {
    await _notesCollection.doc(note.id).update(note.toMap());
  }

  // Delete a note
  Future<void> deleteNote(String noteId) async {
    await _notesCollection.doc(noteId).delete();
  }

  // // Stream of all notes
  // Stream<List<Note>> getNotes() {
  //   return _notesCollection
  //       .orderBy('timestamp', descending: true)
  //       .snapshots()
  //       .map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       return Note.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  //     }).toList();
  //   });
  // }
  Stream<List<Note>> getNotes() {
  final user = _auth.currentUser;
  if (user == null) throw Exception("User not logged in");

  return _notesCollection
      .where('userId', isEqualTo: user.uid) // Filter by user ID
      .snapshots()
      .map((snapshot) {
    final notes = snapshot.docs.map((doc) {
      return Note.fromMap(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();
    // Sort by timestamp in descending order
    notes.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return notes;
  });
}
}