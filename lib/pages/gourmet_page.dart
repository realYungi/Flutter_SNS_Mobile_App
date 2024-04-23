import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/drawer.dart';
import 'package:uridachi/components/gourmet_text.dart';
import 'package:uridachi/components/my_textfield.dart';
import 'package:uridachi/components/gourmet_post.dart';
import 'package:uridachi/components/wallpost.dart';
import 'package:uridachi/helper/helper_methods.dart';
import 'package:uridachi/pages/auth_page.dart';
import 'package:uridachi/pages/chat_page.dart';
import 'package:uridachi/pages/profile_page.dart';


import 'package:intl/intl.dart';


class GourmetPage extends StatefulWidget {
  const GourmetPage({super.key});

  @override
  State<GourmetPage> createState() => _GourmetPageState();
}

class _GourmetPageState extends State<GourmetPage> {
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
    title: const Text("Gourmet Page"),
    backgroundColor: Colors.white,
    
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
      
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
  stream: FirebaseFirestore.instance.collection("Gourmet Posts").snapshots(),
 builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasData) {
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        var doc = snapshot.data!.docs[index];
        var data = doc.data() as Map<String, dynamic>;

        // Safe casting of dynamic list to List<String>
        List<String> likes = List<String>.from(data['likes'] ?? []);
        List<String> imageUrls = List<String>.from(data['imageUrls'] ?? []);

        if (data['postType'] == 'text') {
          return GourmetText(
            titleofpost: data['titleofpost'],
            content: data['content'],
            user: data['email'] ?? 'Unknown User',
            time: DateFormat('kk:mm').format((data['datePublished'] as Timestamp).toDate()),
            postId: doc.id,
            likes: likes,
            rating: (data['rating'] ?? 0.0).toDouble(),
            location: data['location'] ?? 'Unknown Location',
          );
        } else {
          return GourmetPost(
            titleofpost: data['titleofpost'],
            content: data['content'],
            user: data['email'] ?? 'Unknown User',
            time: DateFormat('kk:mm').format((data['datePublished'] as Timestamp).toDate()),
            postId: doc.id,
            likes: likes,
            imageUrls: imageUrls,
            rating: (data['rating'] ?? 0.0).toDouble(),
            location: data['location'] ?? 'Unknown Location',
          );
        }
      },
    );
  } else if (snapshot.hasError) {
    return Text('Error: ${snapshot.error}');
  } else {
    return Center(child: CircularProgressIndicator());
  }
},

  

)


            ),
            
            
          ],
        ),
      ),
    );
  }
}
