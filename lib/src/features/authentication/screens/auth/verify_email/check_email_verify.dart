import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/signup/signup.dart';
import 'package:hobin_warehouse/src/features/authentication/screens/auth/verify_email/email_verify_screen.dart';

class CheckEmailScreen extends StatelessWidget {
  const CheckEmailScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const EmailVerifyScreen();
            } else {
              return const SignUpScreen();
            }
          },
        ),
      );
}
