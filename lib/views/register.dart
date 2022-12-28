// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
                        final userCredential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );
                        print(userCredential);

                        final user = FirebaseAuth.instance.currentUser;
                        if (user != null && !user.emailVerified) {
                          await user.sendEmailVerification();
                        }

                        Future.delayed(const Duration(seconds: 1), () {
                          // Navigator.of(context).pop();
                          Navigator.of(context).pushReplacementNamed(verify);
                        });
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'weak-password') {
                          throw WeakPasswordAuthException();
                        } else if (e.code == 'email-already-in-use') {
                          throw EmailAlreadyInUseAuthException();
                        } else {
                          throw UserNotLoggedInException();
                        }
                      } catch (e) {
                        throw GenericAuthException();
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
