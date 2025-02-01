import 'package:authentication_test/auth/auth_view_model.dart';
import 'package:authentication_test/components/noteCard.dart';
import 'package:authentication_test/models/note_model.dart';
import 'package:authentication_test/note_management/AddEditNoteView.dart';
import 'package:authentication_test/note_management/Single_note_view.dart';
import 'package:authentication_test/note_management/note_view_model.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final noteViewModel = Provider.of<NoteViewModel>(context, listen: false);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
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
        child: StreamBuilder<List<Note>>(
          stream: noteViewModel.notesStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text("Error: \${snapshot.error}"));
            }

            final notes = snapshot.data ?? [];

            if (notes.isEmpty) {
              return const Center(
                  child: Text("No notes available",
                      style: TextStyle(color: Colors.white)));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "All Notes",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      IconButton(
                          onPressed: () {
                            authViewModel.signOut();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                "login", (route) => false);
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: screenWidth > 600 ? 3 : 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        if (note.id == null ||
                            note.title == null ||
                            note.content == null) {
                          return const SizedBox();
                        }
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SingleNoteView(
                                  title: note.title ?? "Untitled",
                                  content: note.content ?? "No content",
                                ),
                              ),
                            );
                          },
                          child: NoteCard(
                            title: note.title ?? "Untitled",
                            content: note.content ?? "No content",
                            onDelete: () async {
                              // Wrap it in an async function
                             
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.warning,
                                animType: AnimType.rightSlide,
                                title: 'Attention',
                                desc: 'Are you sure do you want to delete?',
                                descTextStyle: TextStyle(color: Colors.white),
                                titleTextStyle: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30),
                                btnOkColor: Color.fromARGB(255, 83, 0, 173),
                                dialogBackgroundColor: Color(0xFF6A11CB),
                                btnCancelOnPress: () {},
                                btnOkText: "Yes",
                                btnOkOnPress: ()async {
                                   await noteViewModel
                                  .deleteNote(note.id.toString());
                                },
                              ).show();
                            },
                            onUpdate: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => AddEditNoteView(
                                    noteId: note.id,
                                    initialTitle: note.title,
                                    initialContent: note.content,
                                  ),
                                ),
                              );
                              // await noteViewModel.updateNote(note);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddEditNoteView(),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Color(0xFF6A11CB),
          size: 30,
        ),
      ),
    );
  }
}
