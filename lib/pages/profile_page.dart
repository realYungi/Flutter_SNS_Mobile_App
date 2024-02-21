import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uridachi/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Future<void> editField(String field) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile Page",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 185, 222, 207),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          Icon(
            Icons.person,
            size: 72,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            currentUser.email!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              'My Information',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          TextBox(
              text: 'gagaqu',
              sectionName: 'username',
              onPressed: () => editField('username')
          ),


          TextBox(
              text: 'empty bio',
              sectionName: 'bio',
              onPressed: () => editField('bio')
          ),

const SizedBox(
            height: 50,
          ),

          
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              'My Posts',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),


        ],
      ),
    );
  }
}
