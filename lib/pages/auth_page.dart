import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uridachi/mainpage.dart';
import 'package:uridachi/pages/home_page.dart';
import 'package:uridachi/pages/login_or_register_page.dart';
import 'package:uridachi/screen/verification_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MainPage();
          }
          else {
            return LoginOrRegisterPage();
          }
        },

      ),

    );
  }
}