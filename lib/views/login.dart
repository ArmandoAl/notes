// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/routes.dart';
import '../components/show_error.dart';
import '../services/auth/auth_exceptions.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  int veryfuNum = 0;

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
        title: const Text("Login"),
      ),
      body: Column(
        children: [
          const Text(
            "My Notes",
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
                          .loginIn(email: email, password: password);

                      print("Succesfull");
                      final user = AuthService.firebase().currentUser;
                      print(user);
                      if (user != null) {
                        if (user.isEmailVerified == false) {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              verify, (route) => false);
                        } else {
                          Future.delayed(const Duration(seconds: 1), () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                home, (route) => false);
                          });
                        }
                      }
                    } on UserNotFooundAuthException {
                      await showmessage(context, "User not found");
                    } on WrongPasswordAuthException {
                      await showmessage(context, "Wrong password");
                    } on EmailAlreadyInUseAuthException {
                      await showmessage(context, "Email already in use");
                    } on InvalidEmailAuthException {
                      await showmessage(context, "Invalid email");
                    } on WeakPasswordAuthException {
                      await showmessage(context, "Weak password");
                    } on GenericAuthException {
                      await showmessage(context, "Generic error");
                    } on UserNotLoggedInException {
                      await showmessage(context, "User not logged in");
                    } on UserNotVerifiedException {
                      await showmessage(context, "User not verified");
                    } catch (e) {
                      await showmessage(context, "Unknown error");
                    }
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(register, (route) => false);
                },
                child: const Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
