// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/components/show_error.dart';
import 'package:mynotes/services/auth_service.dart';
import 'package:mynotes/views/routes.dart';

import '../services/auth_exceptions.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              "Register",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 300,
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _email,
                    enableSuggestions: false,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: "Enter your email",
                    ),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      hintText: "Enter your password",
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final email = _email.text;
                      final password = _password.text;

                      try {
                        await AuthService.firebase()
                            .signUp(email: email, password: password);
                        AuthService.firebase().sendEmailVerification();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamed(verify);
                      } on WeakPasswordAuthException {
                        await showmessage(context, "Week password");
                      } on InvalidEmailAuthException {
                        await showmessage(context, "Invalid email");
                      } on EmailAlreadyInUseAuthException {
                        await showmessage(context, "Email already in use");
                      } on FirebaseAuthException catch (e) {
                        await showmessage(
                            context, "Error: ${e.message.toString()}");
                      }
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
