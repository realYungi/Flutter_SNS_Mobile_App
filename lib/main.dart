import 'package:flutter/material.dart';
import 'package:uridachi/pages/auth_page.dart';
import 'package:uridachi/pages/loginpage.dart';
import 'package:uridachi/theme/dark_theme.dart';
import 'package:uridachi/theme/light_theme.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: AuthPage(),
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
    );
  }
}

