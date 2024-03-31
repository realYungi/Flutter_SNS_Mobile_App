import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/email_input_field.dart';
import 'package:uridachi/components/my_button.dart';
import 'package:uridachi/components/my_textfield.dart';
import 'package:uridachi/components/my_dropdown_bar.dart';
import 'package:uridachi/pages/auth_page.dart';
import 'package:uridachi/screen/verification_screen.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nationalityController = TextEditingController();
  final usernameController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String selectedDomain = "fuji.waseda.jp"; // Initial selected domain


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
    },
  );

  if (passwordController.text != confirmPasswordController.text) {
    Navigator.pop(context);
    showErrorMesssage("Passwords don't match");
    return;
  }

String emailAddress = '${emailController.text.trim()}@${selectedDomain.trim()}';

  // Creating user
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: passwordController.text.trim(),
    );

    // After creating the user, save user data to Firestore
    await _firestore.collection("Users").doc(userCredential.user!.email).set({
      'uid': userCredential.user!.uid,
      'email': emailAddress,
      'university': selectedValue,
      'username': usernameController.text,
      'bio': 'Empty Bio..',
      'nationality': nationalityController.text,
    });

    if (context.mounted) Navigator.pop(context);

    // Navigate to AuthPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context);
    showErrorMesssage(e.code);
  }
}
List<String> getDomainOptions(String university) {
    switch (university) {
      case 'Waseda':
        return ["fuji.waseda.jp", "asagi.waseda.jp", "gmail.com"];
      case 'Keio':
        return ["keio.jp", "keio.keio2.jp"];
      default:
        return ["schooldomain.com"]; // Default domain options
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
                        // Update the selected domain based on the new university selection
                        selectedDomain = getDomainOptions(newValue!).first;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  EmailInputField(
                    controller: emailController,
                    domainOptions: getDomainOptions(selectedValue!),
                    selectedDomain: selectedDomain,
                    onDomainChanged: (newValue) {
                      setState(() {
                        selectedDomain = newValue;
                      });
                    },
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
                    text: "Sign Up",
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
                      MyButton(
  text: 'Already have an account? Log In Here',
  onTap: widget.onTap,
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