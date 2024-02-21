import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/my_button.dart';
import 'package:uridachi/components/my_textfield.dart';
import 'package:uridachi/components/my_dropdown_bar.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final universityController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nationalityController = TextEditingController();
  final usernameController = TextEditingController();

  String? selectedValue;
  List<String> options = [
    'Waseda',
    'Keio',
    'Tokyo',
    'Seoul',
    'Yonsei',
    'Korea'
  ];

  @override
  void initState() {
    super.initState();
    selectedValue = options.first;
  }

  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      if (passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      } else {
        showErrorMesssage("Passwords don't match!!");
      }
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);

      showErrorMesssage(e.code);
    }
  }

  void showErrorMesssage(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Center(
              child: Text(
            message,
            style: const TextStyle(color: Colors.white),
          )),
        );
      },
    );
  }

  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text("Incorrect Password"),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 185, 222, 207),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF4FD9B8), // Start color of the gradient
                Color(0xFFE3FFCD), // End color of the gradient
              ],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    'assets/images/logo.png',
                    width: 50, // Specify the width as needed
                    height: 50, // Specify the height as needed
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MyDropdownBar(
                    defaultValue: selectedValue,
                    options: options,
                    onChanged: (newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                      // Here you can also call any logic to save the user's selection, e.g., a function to update a database or shared preferences
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MyTextField(
                    height: 30,
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MyTextField(
                    height: 30,
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MyTextField(
                    height: 30,
                    controller: confirmPasswordController,
                    hintText: "Confirm Password",
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MyTextField(
                    height: 30,
                    controller: nationalityController,
                    hintText: "Nationality",
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  MyTextField(
                    height: 30,
                    controller: usernameController,
                    hintText: "Username",
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  MyButton(
                    text: "Send Verification Code",
                    onTap: signUserUp,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or Register Here',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Already have an account? Log In Here',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
