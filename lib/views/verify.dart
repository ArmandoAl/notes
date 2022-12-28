// ignore_for_file: avoid_print

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/views/routes.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify"),
      ),
      body: Center(
        child: Column(
          children: [
            const Text("We sent an email to confirm your account"),
            const SizedBox(
              height: 300,
            ),
            const Text("If you havent received the email click on the button"),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                print("Verification email sent");
                print(user);
                // timer = Timer.periodic(
                //   const Duration(seconds: 5),
                //   (timer) async {
                //     await user?.reload();
                //     print(user);
                //     if (user?.emailVerified == true) {
                //       print("Email verified");
                //       timer.cancel();
                //     }
                //   },
                // );

                // ignore: use_build_context_synchronously
              },
              child: const Text(
                "Verify",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(home, (route) => false);
              },
              child: const Text(
                "Go to Login",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
