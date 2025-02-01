
import 'package:authentication_test/note_management/AddEditNoteView.dart';
import 'package:authentication_test/auth/auth_view_model.dart';
import 'package:authentication_test/auth/login.dart';
import 'package:authentication_test/auth/signup.dart';
import 'package:authentication_test/home_page.dart';
import 'package:authentication_test/note_management/Single_note_view.dart';
import 'package:authentication_test/note_management/note_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
         ChangeNotifierProvider(create: (_) => NoteViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: authViewModel.isAuthenticated ? const HomeView() : const LoginView(),
      routes: {
        "signup": (context) => const SignupView(),
        "login": (context) => const LoginView(),
        "homepage": (context) => const HomeView(),
        "AddEditNoteView": (context) => const AddEditNoteView(),
          
      },
    );
  }
}
