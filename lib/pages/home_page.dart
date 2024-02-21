import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/my_textfield.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  void signUserOut () {
    FirebaseAuth.instance.signOut();

  }


  void postMessage () {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("日韓 SNS"),
        actions: [IconButton(onPressed: signUserOut, 
        icon: Icon(Icons.logout))],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Row(
              children: [
                Expanded(
                  child: MyTextField(
                    controller: textController,
                    hintText: 'Write something on the wall',
                    obscureText: false,
                    height: 30,
                  ),
                  ),
            
            
                  IconButton(
                    onPressed: postMessage, 
                    icon: const Icon(Icons.arrow_circle_up
                    )
                  ),
            
              ],
            ),
          ),

          Text("Logged in as : " + currentUser.email!),
        ],
      ),
    );
  }
}