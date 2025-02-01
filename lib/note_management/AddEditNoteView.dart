import 'package:authentication_test/models/note_model.dart';
import 'package:authentication_test/note_management/note_view_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddEditNoteView extends StatefulWidget {
  final String? noteId;
  final String? initialTitle;
  final String? initialContent;

  const AddEditNoteView({
    super.key,
    this.noteId,
    this.initialTitle,
    this.initialContent,
  });

  @override
  State<AddEditNoteView> createState() => _AddEditNoteViewState();
}

class _AddEditNoteViewState extends State<AddEditNoteView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if editing an existing note
    if (widget.initialTitle != null) {
      _titleController.text = widget.initialTitle!;
    }
    if (widget.initialContent != null) {
      _contentController.text = widget.initialContent!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteViewModel = Provider.of<NoteViewModel>(context, listen: false);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth > 600 ? 40 : 16,
              vertical: 16,
            ),
            children: [
              SizedBox(
                height: 30,
              ),
              // Custom Header with Back Button
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.noteId == null ? "Add Note" : "Edit Note",
                    style: TextStyle(
                      fontSize: screenWidth > 600 ? 32 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: "Title",
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.title, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
                style: const TextStyle(color: Colors.white),
                validator: (value) =>
                    value!.isEmpty ? "Title is required" : null,
              ),
              const SizedBox(height: 20),
              // Content Field
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: "Content",
                  labelStyle: const TextStyle(color: Colors.white70),
                  prefixIcon: const Icon(Icons.note, color: Colors.white70),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                ),
                style: const TextStyle(color: Colors.white),
                maxLines: screenWidth > 600 ? 15 : 10,
                validator: (value) =>
                    value!.isEmpty ? "Content is required" : null,
              ),
              const SizedBox(height: 30),
              // Save Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final title = _titleController.text;
                    final content = _contentController.text;

                    if (widget.noteId == null) {
                      // Add a new note
                      await noteViewModel.addNote(title, content);
                    } else {
                      // Update an existing note
                      final note = Note(
                        id: widget.noteId,
                        title: title,
                        content: content,
                        timestamp: DateTime.now(),
                        userId: _auth.currentUser!.uid,
                      );
                      await noteViewModel.updateNote(note);
                    }

                    Navigator.of(context).pop();
                  }
                  if (_formKey.currentState!.validate() == false) {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Attention',
                      desc: 'All fields are required',
                      descTextStyle: TextStyle(color: Colors.white),
                      titleTextStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 30),
                      btnOkColor: Color.fromARGB(255, 83, 0, 173),
                      dialogBackgroundColor: Color(0xFF6A11CB),
                      btnOkOnPress: () {},
                    ).show();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  widget.noteId == null ? "Save" : "Update",
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 20 : 18,
                    color: const Color(0xFF6A11CB),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
