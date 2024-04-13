import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/drawer.dart';
import 'package:uridachi/components/my_textfield.dart';
import 'package:uridachi/components/social_post.dart';
import 'package:uridachi/components/wallpost.dart';
import 'package:uridachi/helper/helper_methods.dart';
import 'package:uridachi/pages/auth_page.dart';
import 'package:uridachi/pages/chat_page.dart';
import 'package:uridachi/pages/profile_page.dart';

import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  final textController = TextEditingController();

 void signUserOut() {
  FirebaseAuth.instance.signOut().then((_) {
    // Pop all routes off the stack and navigate to the AuthPage
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const AuthPage()),
      (Route<dynamic> route) => false,
    );
  });
}


 

  void goToProfilePage() {
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfilePage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
    title: const Text("日韓 SNS"),
    backgroundColor: Colors.white,
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.chat),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatPage()),
          );
        },
        color: Colors.black, // Set the icon color to match your AppBar's theme
      ),
    ],
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(4.0), // Height of the gradient line
      child: Container(
        height: 4.0, // Height of the gradient line
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
      ),
    ),
  ),
      drawer: MyDrawer(
        onProfileTap: goToProfilePage,
        onSignOut: signUserOut,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
  stream: FirebaseFirestore.instance.collection("Social Posts").snapshots(),
  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          var post = snapshot.data!.docs[index].data() as Map<String, dynamic>;
          var postId = snapshot.data!.docs[index].id;
          
          // Directly use the email from the post, assuming it's stored there
          // Alternatively, use the email from the FirebaseAuth instance if the post data doesn't include it
          var email = post['email'] ?? FirebaseAuth.instance.currentUser?.email ?? 'Unknown User';

          // Now you can directly use the email as the username
          return SocialPost(
            description: post['description'],
            content: post['content'],
            user: email,  // Use the email as the user identifier
            time: DateFormat('yyyy-MM-dd – kk:mm').format((post['datePublished'] as Timestamp).toDate()),
            postId: postId,
            likes: List<String>.from(post['likes'] ?? []),
            imageUrls: List<String>.from(post['imageUrls'] ?? []),
          );
        },
      );
    } else if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    } else {
      return Center(child: CircularProgressIndicator());
    }
  },


),


            ),

            
           
          ],
        ),
        
      ),
    );
  }
}
