import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/my_textfield.dart';
import 'package:uridachi/components/wallpost.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final currentUser = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void postMessage() {
    //making sure only to post contents where the textfields are filled in 
    if (textController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection("User Posts").add({
        'UserEmail' : currentUser.email,
        'Message' : textController.text,
        'TimeStamp' : Timestamp.now(),
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("日韓 SNS"),
        actions: [IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))],
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder( 
                //ordering by the time the posts have been posted
                stream: FirebaseFirestore.instance
                    .collection("User Posts")
                    .orderBy(
                      "TimeStamp",
                      descending: false,
                    )
                    .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                    
                          itemBuilder: (context, index){
        
                          final post = snapshot.data!.docs[index];
                          return WallPost(
                            message: post['Message'], 
                            user: post['UserEmail'], 
              
                            
                          );
        
                        }, 
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error:${snapshot.error}'),
                        );
        
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
              ),
            ),
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
                      icon: const Icon(Icons.arrow_circle_up)),
                ],
              ),
            ),
            Text("Logged in as : " + currentUser.email!),
          ],
        ),
      ),
    );
  }
}
