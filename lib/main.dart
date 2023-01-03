// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/firebase_options.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/login.dart';
import 'package:mynotes/views/notes/new_notes_view.dart';
import 'package:mynotes/views/notes/notes.dart';
import 'package:mynotes/views/register.dart';
import 'package:mynotes/views/routes.dart';
import 'package:mynotes/views/verify.dart';
// import 'dart:developer' as devtools show log;

void main() {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyNotes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        home: (context) => const HomePage(),
        login: (context) => const Login(),
        register: (context) => const Register(),
        verify: (context) => const Verify(),
        newNote: (context) => const NewNote(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService.firebase().currentUser;
            if (user != null) {
              if (user.isEmailVerified) {
                print(user);
                return const Center(
                  child: Start(),
                );
              } else {
                return const Center(
                  child: Verify(),
                );
              }
            } else {
              return const Center(
                child: Login(),
              );
            }
          default:
            return const Text("Loading...");
        }
      },
    );
  }
}
