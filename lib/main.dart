// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/login.dart';
import 'package:mynotes/views/register.dart';
import 'package:mynotes/views/routes.dart';
import 'package:mynotes/views/verify.dart';

import 'firebase_options.dart';
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
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum MenuAction { logout }

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
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              if (user.emailVerified) {
                print(user);
                return Center(
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

  // ignore: non_constant_identifier_names
  Widget Start() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (MenuAction result) async {
              switch (result) {
                case MenuAction.logout:
                  await singout(context).then((value) {
                    if (value == true) {
                      FirebaseAuth.instance.signOut();
                    }
                  });
                  // ignore: use_build_context_synchronously

                  // ignore: use_build_context_synchronously
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(login, (route) => false);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuAction>>[
              const PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text("Logout"),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "My Notes Project",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Image.asset(
              "../images/book.png",
              height: 100,
              width: 100,
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> singout(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Are you sure?"),
              content: const Text("Do you want to logout?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text("Yes"),
                ),
              ],
            ));
  }
}
