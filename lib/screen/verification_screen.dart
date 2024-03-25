import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/my_button.dart';
import 'package:uridachi/components/my_textfield.dart';
import 'package:uridachi/mainpage.dart';
import 'package:uridachi/screen/verify_screen.dart';

class VerificationScreen extends StatefulWidget {

  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  bool isEmailVerified = false;
  late Timer timer;

  @override
  void initState () {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerficationEmail();

      Timer.periodic(
        Duration(seconds: 3),
        (_) => MainPage(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {

    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }


  Future sendVerficationEmail() async {
    try{
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
       Navigator.pop(context);

      showErrorMesssage("Please Verify Your Email");
    }
  }



void showErrorMesssage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 183, 255, 169),
          title: Center(
              child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          )),
        );
      },
    );
}

  @override
  Widget build(BuildContext context) => isEmailVerified
    ? VerifyScreen()
    : Scaffold(
      appBar: AppBar(
        title: Text('Verify Email'),
      ),
    );
}
