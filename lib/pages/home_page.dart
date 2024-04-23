import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/drawer.dart';
import 'package:uridachi/components/my_textfield.dart';
import 'package:uridachi/components/social_post.dart';
import 'package:uridachi/components/text_post.dart';
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
              child: StreamBuilder<QuerySnapshot>(
  stream: FirebaseFirestore.instance.collection('Social Posts').orderBy('datePublished', descending: true).snapshots(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasError) {
      return Text("Something went wrong");
    }
    if (!snapshot.hasData) {
      return Text("No data available");
    }

    return ListView.builder(
  itemCount: snapshot.data!.docs.length,
  itemBuilder: (context, index) {
    var doc = snapshot.data!.docs[index];
    var data = doc.data() as Map<String, dynamic>;

    // Ensure the correct handling based on postType
    if (data['postType'] == 'text') {
      // TextPost expected parameters handled
      return TextPost(
        titleofpost: data['titleofpost'], // make sure the field name in Firestore matches 'titleofpost'
        content: data['content'],
        user: data['email'] ?? 'Unknown User',
        time: DateFormat('kk:mm').format((data['datePublished'] as Timestamp).toDate()),
        postId: doc.id,
        likes: List<String>.from(data['likes']),
      );
    } else {
      // SocialPost expected parameters handled
      return SocialPost(
        titleofpost: data['titleofpost'], // Same here for SocialPost
        content: data['content'],
        user: data['email'] ?? 'Unknown User',
        time: DateFormat('kk:mm').format((data['datePublished'] as Timestamp).toDate()),
        postId: doc.id,
        likes: List<String>.from(data['likes']),
        imageUrls: List<String>.from(data['imageUrls']),
      );
    }
  },
);

  },
)



            ),

            
           
          ],
        ),
        
      ),
    );
  }
}
